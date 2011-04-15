//
//  WebArticlesController.m
//  ReadItLater
//
//  Created by Student on 15/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "WebArticlesController.h"


@implementation WebArticlesController

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
	feedContent = [[NSMutableData alloc] init];
	[self startFeedRefresh];
    [super viewDidLoad];
}


-(IBAction) refreshFeedClicked:(id) sender {
	[self startFeedRefresh];
}


- (void)startFeedRefresh {
	[waitIcon startAnimating];
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
