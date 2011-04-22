//
//  ReadItLaterViewController.m
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "RootController.h"
#import "SavedArticleController.h"
#import "WebArticlesController.h"
#import "ReadItLaterDelegate.h"
#import "Article.h"

@implementation RootController

@synthesize tableSavedArticles;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Read It Later";
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	articles = delegate.articles;
	delegate.navController.delegate = self;
    [super viewDidLoad];
}


- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];	
	if (viewController == self && delegate.needDataRefresh) {
		[delegate readArticlesFromDatabaseWithPath:delegate.savedFilePath];
		articles = delegate.articles; // update link
		[self.tableSavedArticles reloadData];
	}
}


- (UITableViewCell *) tableView:(UITableView *) tv
 cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];
	}
	Article *thisArticle = [articles objectAtIndex: indexPath.row];
	cell.textLabel.text = thisArticle.title;
	return cell;
}


- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection: (NSInteger) section
{
	return [articles count];
}


- (void) tableView:(UITableView *) tv
	didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	SavedArticleController *savedArticle = [[SavedArticleController alloc] initWithIndexPath:indexPath];
	[delegate.navController pushViewController:savedArticle animated:YES];
	[savedArticle release];
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}


-(IBAction) addArticlesClicked:(id) sender {
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	WebArticlesController *webArticlesView = [[WebArticlesController alloc] init];
	[delegate.navController pushViewController:webArticlesView animated:YES];
	[webArticlesView release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableSavedArticles release];
	[articles release];
    [super dealloc];
}

@end
