//
//  WebArticlesController.h
//  ReadItLater
//
//  Created by Student on 15/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface WebArticlesController : UIViewController 
	<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate> {
	NSMutableArray	*onlineArticles;
	UITableView		*tableOnlineArticles;
	Article			*currentArticle;
	NSMutableData *feedContent;  // old method
	IBOutlet UIActivityIndicatorView *waitIcon;

	
	//NSString * feed;
	NSString *currentElement;  
	//NewsItem * item;
		NSMutableString *currentTitle;
		NSMutableString *currentDescription;
		NSMutableString *currentLink;
		NSMutableString *currentPubDate;
		NSMutableString *currentAuthor;
		NSMutableString *currentCategory;
		NSMutableString *currentComments;
		NSMutableString *currentGuid;
		NSMutableString *currentSource;
		
//	NSMutableArray * newsItems;
}

//@property (nonatomic, retain) NSMutableArray * newsItems;
//@property (nonatomic, retain) NSString * feed;
@property (retain, nonatomic) NSMutableString *currentTitle;
@property (retain, nonatomic) NSMutableString *currentDescription;
@property (retain, nonatomic) NSMutableString *currentLink;
@property (retain, nonatomic) NSMutableString *currentPubDate;
@property (retain, nonatomic) NSMutableString *currentAuthor;
@property (retain, nonatomic) NSMutableString *currentCategory;
@property (retain, nonatomic) NSMutableString *currentComments;
@property (retain, nonatomic) NSMutableString *currentGuid;
@property (retain, nonatomic) NSMutableString *currentSource;

@property (nonatomic, retain) IBOutlet UITableView     *tableOnlineArticles;


@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *waitIcon;

- (IBAction) refreshFeedClicked:(id) sender;
- (void)startFeedRefresh;
- (void) loadFeed;


@end
