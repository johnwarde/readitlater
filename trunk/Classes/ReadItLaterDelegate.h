//
//  ReadItLaterAppDelegate.h
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootController;

@interface ReadItLaterDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootController *viewController;
	NSMutableArray *articles;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *articles;

-(NSString *)copyDatabaseToDocuments;
-(void) readArticlesFromDatabaseWithPath:(NSString *) filePath;

@end

