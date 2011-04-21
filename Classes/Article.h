//
//  Article.h
//  ReadItLater
//
//  Created by Student on 12/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 title	 TEXT(255)	 Yes	 Yes	 Defines the title of the item
 description	 TEXT(4096)	 Yes	 Yes	 Describes the item
 link	 TEXT(512)	 Yes	 Yes	 Defines the hyperlink to the item
 pubDate	 TEXT(50)	 No	 Yes	 Defines the last-publication date for the item
 author	 TEXT(128)	 No	 Yes	 Specifies the e-mail address to the author of the item
 category	 TEXT(255)	 No	 Yes	 Defines one or more categories the item belongs to
 comments	 TEXT(255)	 No	 Yes	 Allows an item to link to comments about that item
 guid	 TEXT(255)	 No	 Yes	 Defines a unique identifier for the item
 source	 TEXT(255)	 No	 Yes	 Specifies a third-party source for the item
 read	 INTEGER	Yes	 No	 Indicates that the item has been read by the iPhone user
 deleted	 INTEGER	 Yes	 No	 Indicates that the item has been deleted by the iPhone user, these will be deleted from the DB on app exit
 enclosure	 TEXT(???)	No	Yes	Allows a media file to be included with the item, not used in initial version
 */

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
