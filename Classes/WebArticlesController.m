//
//  WebArticlesController.m
//  ReadItLater
//
//  Created by Student on 15/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "WebArticlesController.h"
#import "ReadItLaterDelegate.h"
#import "Article.h"

@implementation WebArticlesController

@synthesize tableOnlineArticles;

@synthesize currentTitle;
@synthesize currentDate;
@synthesize currentSummary;
@synthesize currentLink;
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
	[waitIcon startAnimating];
	[self loadFeed];
	[waitIcon stopAnimating];
	return;
	
	NSString *string = [NSString stringWithFormat:@"http://readitlater.googlecode.com/files/rss.xml"];
	NSURL *url = [[NSURL URLWithString:string] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
										  timeoutInterval:10];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

	
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
	NSURL * url = [NSURL URLWithString:@"http://readitlater.googlecode.com/files/rss.xml"];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[xmlParser setDelegate:self];

	[onlineArticles release]; // release last refresh
	onlineArticles = [[NSMutableArray alloc] init];
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
	
	//Article thisArticle = [[Article alloc] init];
//	Article thisArticle;
	for (int i = 0; i < [onlineArticles count]; i++) {
		currentArticle = [onlineArticles objectAtIndex:i];
		NSLog(@"Article %d: title = [%@], link = [%@], description = [%@], ", i, currentArticle.title, currentArticle.link, currentArticle.description);
	}
	
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
        [self.currentSummary appendString:string];  
    } else if ([currentElement isEqualToString:@"pubDate"]) {  
        [self.currentDate appendString:string];  
        NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];  
        [self.currentDate setString: [self.currentDate stringByTrimmingCharactersInSet: charsToTrim]];  
    }  
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];  
	
    if ([elementName isEqualToString:@"item"]) {  
        currentArticle = [[Article alloc] init];
        currentTitle = [[NSMutableString alloc] init];  
        currentDate = [[NSMutableString alloc] init];  
        currentSummary = [[NSMutableString alloc] init];  
        currentLink = [[NSMutableString alloc] init];
    }  
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) 
	{
	
        currentArticle.title = currentTitle;  
        currentArticle.link = currentLink;
		currentArticle.description = currentSummary;

        // Parse date here  
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];  
		
        [dateFormatter setDateFormat:@"E, d LLL yyyy HH:mm:ss Z"]; // Thu, 18 Jun 2010 04:48:09 -0700  
        NSDate *date = [dateFormatter dateFromString:self.currentDate];  		

        currentArticle.pubdate = date;
		[onlineArticles addObject:currentArticle];
		
		NSLog(@"addObject: tite = [%@]", elementName);
		NSLog(@"addObject: tite = [%@]", currentTitle);
		NSLog(@"addObject: tite = [%@]", currentSummary);
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
	
	
/*	
	SavedArticleController *savedArticle = [[SavedArticleController alloc] initWithIndexPath:indexPath];
	[delegate.navController pushViewController:savedArticle animated:YES];
	[savedArticle release];
*/	
	
	//Article *thisArticle = [articles objectAtIndex:indexPath.row];
	/*
	 UIAlertView *alert = [[UIAlertView alloc] 
	 initWithTitle:thisArticle.title 
	 message:thisArticle.link 
	 delegate:self 
	 cancelButtonTitle:nil 
	 otherButtonTitles:@"OK", nil];
	 [alert show];
	 [alert release];
	 */
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
