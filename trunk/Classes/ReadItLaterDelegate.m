//
//  ReadItLaterAppDelegate.m
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//


#import "ReadItLaterDelegate.h"
#import "RootController.h"

@implementation ReadItLaterDelegate

@synthesize window;
@synthesize viewController;
@synthesize articles;
@synthesize onlineArticles;
@synthesize navController;
@synthesize savedFilePath;
@synthesize needDataRefresh;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	self.needDataRefresh = NO;
	articles = [[NSMutableArray alloc] init];
	onlineArticles = [[NSMutableArray alloc] init];
	//NSString *filePath = [self copyDatabaseToDocuments];
	//savedFilePath = [self copyDatabaseToDocuments];
	[self copyDatabaseToDocuments];
	//[self readArticlesFromDatabaseWithPath:filePath];
	[self readArticlesFromDatabaseWithPath:savedFilePath];
	// Set the view controller as the window's root view controller and display.
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
	self.savedFilePath = filePath;
	return filePath;
}


/*
-(NSString *) assignWithNullCheck: (sqlite3_stmt *) compiledStatement withFieldNo: (int) fieldNo {
	const char *fieldValue = (const char *)sqlite3_column_text(compiledStatement, fieldNo);
	if (fieldValue != NULL) {
		return [NSString stringWithUTF8String: fieldValue ];
	} else {
		return [NSString stringWithUTF8String: ""];
	}
}
*/

-(const unsigned char *) checkForNullWithResult: (sqlite3_stmt *) compiledStatement withFieldNo: (int) fieldNo {
    const unsigned char *emptyString = (const unsigned char *) "";
	const unsigned char *text = sqlite3_column_text(compiledStatement, fieldNo);
	if (NULL == text) {
		return emptyString;
	}
	return text;
}

-(void) readArticlesFromDatabaseWithPath:(NSString *) filePath {
	NSLog(@"%s: savedFilePath = [%@]", __FUNCTION__, savedFilePath);	
	self.needDataRefresh = NO; // reset 
	[self.articles removeAllObjects];
	sqlite3 *database;
	if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT * FROM articles ORDER BY pubdate";
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				Article *newArticle		= [[Article alloc] init];
				newArticle.articleId	= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 0]];
				newArticle.title		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 1]];
				newArticle.description	= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 2]];
				newArticle.link			= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 3]];	
				newArticle.pubdate		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 4]];
				newArticle.author		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 5]];				
				newArticle.category		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 6]];
				newArticle.comments		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 7]];	
				newArticle.guid			= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 8]];	
				newArticle.source		= [NSString stringWithUTF8String:(char *) [self checkForNullWithResult: compiledStatement withFieldNo: 9]];	
				newArticle.read			= [NSNumber numberWithInt :(int) sqlite3_column_int(compiledStatement, 10)];
				newArticle.deleted		= [NSNumber numberWithInt:(int) sqlite3_column_int(compiledStatement, 11)];
				[self.articles addObject:newArticle];
				[newArticle release];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

-(void) saveArticleToDatabase: (Article *) newArticle {
	NSLog(@"%s: savedFilePath = [%@]", __FUNCTION__, savedFilePath);	
	sqlite3 *database;
	if (sqlite3_open([self.savedFilePath UTF8String], &database) == SQLITE_OK) {
		NSMutableString* sqlPrepare = 
		  [NSMutableString stringWithFormat:@"INSERT INTO articles (title, description, link, pubdate, author, category, guid, source, read, deleted) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", 0, 0)", 
															newArticle.title,
															newArticle.description,
															newArticle.link,
															newArticle.pubdate,
															newArticle.author,
															newArticle.category,
															newArticle.guid,
															newArticle.source
		   ];
		[sqlPrepare replaceOccurrencesOfString:@"(null)" 
												 withString:@"" 
												    options:NSCaseInsensitiveSearch 
													  range:NSMakeRange(0, [sqlPrepare length])];
		NSLog(@"saveArticleToDatabaseWithPath: sql = [%@]", sqlPrepare);
		const char *sqlStatement = [sqlPrepare cStringUsingEncoding: NSISOLatin1StringEncoding];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			NSLog(@"saveArticleToDatabaseWithPath: sql success");
		} else {
			NSLog(@"saveArticleToDatabaseWithPath: sql failed");
		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"Error: %s", sqlite3_errmsg(database) );
		} else {
			NSLog( @"Insert into row id = %d", sqlite3_last_insert_rowid(database));
		}		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}


-(void) deleteArticleIdFromDatabase: (NSString *) targetId {
	NSLog(@"%s: savedFilePath = [%@]", __FUNCTION__, savedFilePath);	
	sqlite3 *database;
	if (sqlite3_open([self.savedFilePath UTF8String], &database) == SQLITE_OK) {
		NSMutableString* sqlPrepare = [NSMutableString stringWithFormat:@"DELETE FROM articles WHERE id =  %@", targetId];
		NSLog(@"deleteArticleIdFromDatabaseWithPath: sql = [%@]", sqlPrepare);
		const char *sqlStatement = [sqlPrepare cStringUsingEncoding: NSISOLatin1StringEncoding];
		
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			NSLog(@"saveArticleToDatabaseWithPath: sql success");
		} else {
			NSLog(@"saveArticleToDatabaseWithPath: sql failed");

		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"Error: %s", sqlite3_errmsg(database) );
		} else {
			NSLog( @"Deleted row id = %@", targetId);
		}	
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

-(void) setReadFlagForArticle:(Article *) targetArticle withValue:(BOOL) boolValue {
	sqlite3 *database;
	NSLog(@"%s: savedFilePath = [%@]", __FUNCTION__, savedFilePath);
	if (sqlite3_open([self.savedFilePath UTF8String], &database) == SQLITE_OK) {
		//const char* strBoolValue = bo
		NSMutableString* sqlPrepare = [NSMutableString stringWithFormat:@"UPDATE articles SET read = %d WHERE id =  %@", 
									   (int) boolValue, targetArticle.articleId];
		NSLog(@"setReadFlagForArticle: sql = [%@]", sqlPrepare);
		const char *sqlStatement = [sqlPrepare cStringUsingEncoding: NSISOLatin1StringEncoding];
		
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			NSLog(@"setReadFlagForArticle: sql success");
		} else {
			NSLog(@"setReadFlagForArticle: sql failed");
			
		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"Error: %s", sqlite3_errmsg(database) );
		} else {
			NSLog( @"Updated row id = %@", targetArticle.articleId);
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
