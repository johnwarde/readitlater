//
//  ReadItLaterAppDelegate.m
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#include <sqlite3.h>
#import "ReadItLaterDelegate.h"
#import "RootController.h"
#import "Article.h"

@implementation ReadItLaterDelegate

@synthesize window;
@synthesize viewController;
@synthesize articles;
@synthesize onlineArticles;
@synthesize navController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	articles = [[NSMutableArray alloc] init];
	onlineArticles = [[NSMutableArray alloc] init];
	NSString *filePath = [self copyDatabaseToDocuments];
	[self readArticlesFromDatabaseWithPath:filePath];
	// Set the view controller as the window's root view controller and display.
    //self.window.rootViewController = self.viewController;
	navController.viewControllers = [NSArray arrayWithObject:viewController];
	[window addSubview:navController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


-(NSString *)copyDatabaseToDocuments {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"readitlater.sqlite"];
	if (![fileManager fileExistsAtPath:filePath]) {
		NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] 
								stringByAppendingPathComponent:@"readitlater.sqlite"];
		[fileManager copyItemAtPath:bundlePath toPath:filePath error:nil];
	}
	return filePath;
}

-(void) readArticlesFromDatabaseWithPath:(NSString *) filePath {
	sqlite3 *database;
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT * FROM articles ORDER BY pubdate";
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *title			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
				NSString *description	= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
				NSString *link			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 3)];
				NSString *pubdate		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
				NSString *author		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 5)];
				NSString *category		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 6)];
				// TODO: Need to check for nil/NULL value being returned from sqlite3_column_text() calls,
				//       Workaround is to enter the "" string for those fields that do not require a value.
				NSString *comments		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 7)];
				NSString *guid			= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 8)];
				NSString *source		= [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 9)];
				NSNumber *read			= [NSNumber numberWithInt :(int) sqlite3_column_int(compiledStatement, 10)];
				NSNumber *deleted		= [NSNumber numberWithInt:(int) sqlite3_column_int(compiledStatement, 11)];
				
				Article *newArticle		= [[Article alloc] init];
				newArticle.title		= title;
				newArticle.description	= description;
				newArticle.link			= link;
				newArticle.pubdate		= pubdate;
				newArticle.author		= author;
				newArticle.category		= category;
				newArticle.comments		= comments;
				newArticle.guid			= guid;
				newArticle.source		= source;
				newArticle.read			= read;
				newArticle.deleted		= deleted;
				
				[self.articles addObject:newArticle];
				[newArticle release];	
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
	[articles release];
	[onlineArticles release];
    [super dealloc];
}


@end
