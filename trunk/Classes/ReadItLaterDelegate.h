//
//  ReadItLaterAppDelegate.h
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#include <sqlite3.h>
#import <UIKit/UIKit.h>
#import "Article.h"

@class RootController;

@interface ReadItLaterDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootController *viewController;
	NSMutableArray *articles;
	NSMutableArray *onlineArticles;
	UINavigationController *navController;
	NSString *savedFilePath;
	BOOL needDataRefresh;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) NSMutableArray *onlineArticles;
@property (nonatomic, retain) NSString *savedFilePath;
@property (nonatomic) BOOL needDataRefresh;

-(NSString *)copyDatabaseToDocuments;
-(const unsigned char *) checkForNullWithResult: (sqlite3_stmt *) compiledStatement withFieldNo: (int) fieldNo;
-(void) readArticlesFromDatabaseWithPath:(NSString *) filePath;
-(void) saveArticleToDatabase: (Article *) newArticle;
-(void) deleteArticleIdFromDatabase: (NSString *) targetId;
-(void) setReadFlagForArticle:(Article *) targetArticle withValue:(BOOL) boolValue;

@end

