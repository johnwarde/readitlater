//
//  AddArticleController.m
//  ReadItLater
//
//  Created by Student on 09/10/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "AddArticleController.h"
#import "ReadItLaterDelegate.h"

@implementation AddArticleController

@synthesize newTitle;
@synthesize newDescription;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(IBAction) saveArticleClicked:(id) sender {
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	
	Article *newArticle = [[Article alloc] init];
	newArticle.title = newTitle.text;
	newArticle.description = newDescription.text;
	
	if ([newArticle.title isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Error" 
							  message:@"Please enter a title"
							  delegate:self 
							  cancelButtonTitle:nil 
							  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		return;
	}
	if ([newArticle.description isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Error" 
							  message:@"Please enter a description"
							  delegate:self 
							  cancelButtonTitle:nil 
							  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		return;
	}	

	newArticle.link = @"";
	// Convert ISO date to a more user friendly format
	NSDate *datePublished = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:datePublished];
	newArticle.pubdate = articleDateString;	
	
	newArticle.author = @"John Warde";
	newArticle.source = @"";
	newArticle.category = @"note to self";
	newArticle.comments = @"";
	[delegate saveArticleToDatabase: newArticle];
	delegate.needDataRefresh = YES;
	[delegate.navController popViewControllerAnimated: YES];
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
    [super dealloc];
}


@end
