//
//  WebArticlesController.m
//  ReadItLater
//
//  Created by Student on 15/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "WebArticlesController.h"
#import "WebArticleController.h"
#import "ReadItLaterDelegate.h"
#import "Article.h"

@implementation WebArticlesController

@synthesize tableOnlineArticles;

@synthesize currentTitle;
@synthesize currentDescription;
@synthesize currentLink;
@synthesize currentPubDate;
@synthesize currentAuthor;
@synthesize currentCategory;
@synthesize currentComments;
@synthesize currentGuid;
@synthesize currentSource;



@synthesize waitIcon;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Online Articles";
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	onlineArticles = delegate.onlineArticles;
	feedContent = [[NSMutableData alloc] init]; // old method
	[self startFeedRefresh];
    [super viewDidLoad];
}


-(IBAction) refreshFeedClicked:(id) sender {
	[self startFeedRefresh];
}


- (void)startFeedRefresh {
	[onlineArticles removeAllObjects];	
	[waitIcon startAnimating];
	[self loadFeed];
	[waitIcon stopAnimating];
	return;
	
/*	
    // This code works, may try asynchronous download of feed again, get the NSXMLParser to parse the downloaded data
	NSString *string = [NSString stringWithFormat:@"http://readitlater.googlecode.com/files/rss.xml"];
	NSURL *url = [[NSURL URLWithString:string] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
										  timeoutInterval:10];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
*/
 }

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



/**************************************************************************/

-(void) loadFeed
{
	//NSURL * url = [NSURL URLWithString:@"http://tunepal.wordpress.com/feed/"];
	//NSURL * url = [NSURL URLWithString:@"http://code.google.com/feeds/p/readitlater/updates/basic"];
	NSURL * url = [NSURL URLWithString:@"http://readitlater.googlecode.com/files/rss.xml"];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	// Can we cast to NSData from feedContent (NSMutableData) 
	//NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: feedContent];
	[xmlParser setDelegate:self];

	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	NSLog(@"error parsing XML: %@", [parseError localizedDescription]);
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry. A problem occured parsing the RSS feed", @"") message:[parseError localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{  
    if ([currentElement isEqualToString:@"title"]) {  
        [self.currentTitle appendString:string];  
    } else if ([currentElement isEqualToString:@"link"]) {  
        [self.currentLink appendString:string];  
    } else if ([currentElement isEqualToString:@"description"]) {  
        [self.currentDescription appendString:string];
    } else if ([currentElement isEqualToString:@"author"]) {  
        [self.currentAuthor appendString:string];
    } else if ([currentElement isEqualToString:@"category"]) {  
        [self.currentCategory appendString:string];
    } else if ([currentElement isEqualToString:@"comments"]) {  
        [self.currentComments appendString:string];
    } else if ([currentElement isEqualToString:@"guid"]) {  
        [self.currentGuid appendString:string];
    } else if ([currentElement isEqualToString:@"source"]) {  
        [self.currentSource appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {  
        [self.currentPubDate appendString:string];  
        NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];  
        [self.currentPubDate setString: [self.currentPubDate stringByTrimmingCharactersInSet: charsToTrim]];  
    }  
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];  
	
    if ([elementName isEqualToString:@"item"]) {  
        currentArticle		= [[Article alloc] init];
        currentTitle		= [[NSMutableString alloc] init];
        currentLink			= [[NSMutableString alloc] init];		
        currentPubDate		= [[NSMutableString alloc] init];  
        currentDescription	= [[NSMutableString alloc] init];
        currentAuthor		= [[NSMutableString alloc] init];
        currentCategory		= [[NSMutableString alloc] init];
        currentComments		= [[NSMutableString alloc] init];
        currentGuid			= [[NSMutableString alloc] init];
        currentSource		= [[NSMutableString alloc] init];
    }  
}


- (void) postProcessFieldValue: (NSMutableString *) targetString {
	NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n\t"];  
	[targetString setString: [targetString stringByTrimmingCharactersInSet: charsToTrim]];
	if ([targetString length] < 1) {
		[targetString setString: @""];
	}
	if ([targetString isEqualToString:@"(null)"]) {
		[targetString setString: @""];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) 
	{
		[self postProcessFieldValue: currentTitle];
		[self postProcessFieldValue: currentLink];
		[self postProcessFieldValue: currentDescription];
		[self postProcessFieldValue: currentPubDate];
		[self postProcessFieldValue: currentCategory];
		[self postProcessFieldValue: currentComments];
		[self postProcessFieldValue: currentGuid];
		[self postProcessFieldValue: currentSource];
	
        currentArticle.title		= currentTitle;  
        currentArticle.link			= currentLink;
		currentArticle.description	= currentDescription;
		currentArticle.pubdate		= currentPubDate;
		currentArticle.author		= currentAuthor;
		currentArticle.category		= currentCategory;
		currentArticle.comments		= currentComments;
		currentArticle.guid			= currentGuid;
		currentArticle.source		= currentSource;

        // Parse date here  
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];  
		
        [dateFormatter setDateFormat:@"E, d LLL yyyy HH:mm:ss Z"]; // Thu, 18 Jun 2010 04:48:09 -0700  
        NSDate *date = [dateFormatter dateFromString:self.currentPubDate];  		

        currentArticle.pubdate = [date description];
		[onlineArticles addObject:currentArticle];
		
		NSLog(@"addObject: elementName = [%@]", elementName);
		
		NSLog(@"addObject: currentArticle.title			= [%@]", currentArticle.title);		
		NSLog(@"addObject: currentArticle.link			= [%@]", currentArticle.link);		
		NSLog(@"addObject: currentArticle.description	= [%@]", currentArticle.description);		
		NSLog(@"addObject: currentArticle.pubdate		= [%@]", currentArticle.pubdate);		
		NSLog(@"addObject: currentArticle.author		= [%@]", currentArticle.author);		
		NSLog(@"addObject: currentArticle.category		= [%@]", currentArticle.category);		
		NSLog(@"addObject: currentArticle.comments		= [%@]", currentArticle.comments);		
		NSLog(@"addObject: currentArticle.guid			= [%@]", currentArticle.guid);		
		NSLog(@"addObject: currentArticle.source		= [%@]", currentArticle.source);			
	}
}


- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	NSLog(@"all done!");
}



/**************************************************************************/


/******************** table mgt ************************************/


- (UITableViewCell *) tableView:(UITableView *) tv
		  cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];
	}
	Article *thisArticle = [onlineArticles objectAtIndex: indexPath.row];
	cell.textLabel.text = thisArticle.title;
	return cell;
}


- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection: (NSInteger) section
{
	return [onlineArticles count];
}


- (void) tableView:(UITableView *) tv
didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	
	

	WebArticleController *webArticle = [[WebArticleController alloc] initWithIndexPath:indexPath];
	[delegate.navController pushViewController:webArticle animated:YES];
	[webArticle release];
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}



/*******************************************************************/




- (NSURLRequest *)connection:(NSURLConnection *)connection
			 willSendRequest:(NSURLRequest *)request
			redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

- (void)connection:(NSURLConnection *)connection
	didReceiveResponse:(NSURLResponse *)response
{
    [feedContent setLength:0];
}

- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data
{
    [feedContent appendData:data];
}

- (void)connection:(NSURLConnection *)
connection didFailWithError:(NSError *)error
{
	//. . . implementation code would go here ...
	[waitIcon stopAnimating];		
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Error" 
						  message:@"Could not retrieve feed from the internet, check your connection"
						  delegate:self 
						  cancelButtonTitle:nil 
						  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release]; 	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//. . . implementation code would go here ...
	NSString *content = [[NSString alloc] initWithBytes:[feedContent bytes] length:[feedContent length] encoding:NSUTF8StringEncoding];
	NSLog(@"Data = %@", content);
	// Can we cast to NSData from feedContent (NSMutableData) 
	[waitIcon stopAnimating];
	[content release];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[waitIcon release];
	[feedContent release];
    [super dealloc];
}


@end
