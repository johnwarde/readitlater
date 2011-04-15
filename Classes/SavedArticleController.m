//
//  SavedArticleController.m
//  ReadItLater
//
//  Created by Student on 14/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "SavedArticleController.h"
#import "ReadItLaterDelegate.h"
#import "Article.h"


@implementation SavedArticleController


@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize linkLabel;
@synthesize dateAndAuthorLabel;
@synthesize sourceLabel;
@synthesize categoryLabel;
@synthesize commentsLabel;



-(id)initWithIndexPath: (NSIndexPath *)indexPath {
	if (self == [super init]) {
		index = indexPath;
	}
	return self;
}


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
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	Article *thisArticle = [delegate.articles objectAtIndex:index.row];
	
	self.title = @"Saved Article";
	titleLabel.text = thisArticle.title;
	descriptionLabel.text = thisArticle.description;
	linkLabel.text = thisArticle.link;

/*
	// Convert ISO date to a more user friendly format
	NSDate *datePublished = [[NSDate alloc] initWithString:thisArticle.pubdate];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:datePublished];
	dateAndAuthorLabel.text = articleDateString;
*/
	dateAndAuthorLabel.text = thisArticle.pubdate;
	if ([thisArticle.author length] > 0) {
		dateAndAuthorLabel.text = [dateAndAuthorLabel.text stringByAppendingString: @", "];
		dateAndAuthorLabel.text = [dateAndAuthorLabel.text stringByAppendingString: thisArticle.author];
	}
	sourceLabel.text	= thisArticle.source;
	categoryLabel.text	= thisArticle.category;
	commentsLabel.text	= thisArticle.comments;	
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[index release];
	[titleLabel release];
	[descriptionLabel release];
	[linkLabel release];
	[dateAndAuthorLabel release];
	[sourceLabel release];
	[categoryLabel release];
	[commentsLabel release];	
    [super dealloc];
}


@end
