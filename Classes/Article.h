//
//  Article.h
//  ReadItLater
//
//  Created by Student on 12/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject {
	NSString *articleId;
	NSString *title;
	NSString *description;
	NSString *link;
	NSString *pubdate;
	NSString *author;
	NSString *category;
	NSString *comments;
	NSString *guid;
	NSString *source;
	NSNumber *read;
	NSNumber *deleted;
}

@property (nonatomic, retain) NSString *articleId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *pubdate;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSNumber *read;
@property (nonatomic, retain) NSNumber *deleted;

@end
