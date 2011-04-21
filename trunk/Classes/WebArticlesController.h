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
    NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;  
//	NSMutableArray * newsItems;
}

//@property (nonatomic, retain) NSMutableArray * newsItems;
//@property (nonatomic, retain) NSString * feed;
@property (retain, nonatomic) NSMutableString *currentTitle;
@property (retain, nonatomic) NSMutableString *currentDate;
@property (retain, nonatomic) NSMutableString *currentSummary;
@property (retain, nonatomic) NSMutableString *currentLink;
@property (nonatomic, retain) IBOutlet UITableView     *tableOnlineArticles;


@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *waitIcon;

- (IBAction) refreshFeedClicked:(id) sender;
- (void)startFeedRefresh;



-(void) loadFeed;
/*
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parserDidEndDocument:(NSXMLParser *)parser;
*/


@end
