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
#import "AddArticleController.h"

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
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewDidLoad];
}


- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];	
	if (viewController == self && delegate.needDataRefresh) {
		[delegate readArticlesFromDatabase];
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
	if (indexPath.row < articles.count) {
		Article *thisArticle = [articles objectAtIndex: indexPath.row];
		cell.textLabel.text = thisArticle.title;
		if (NO == [thisArticle.read boolValue]) {
			cell.textLabel.textColor = [UIColor redColor];
		} else {
			cell.textLabel.textColor = [UIColor blackColor];
		}
	} else {
		cell.textLabel.text = @"Add Note ...";
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *) tv 
  editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath {
	if (indexPath.row < articles.count) {
		return UITableViewCellEditingStyleDelete;
	} else {
		return UITableViewCellEditingStyleInsert;
	}
}


- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection: (NSInteger) section
{
	//return [articles count];
	NSInteger count = [articles count];
	if (self.editing) {
		count++;
	}
	return count;
}


- (void) tableView:(UITableView *) tv
	didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (indexPath.row < articles.count && !self.editing) {
		SavedArticleController *savedArticle = [[SavedArticleController alloc] initWithIndexPath:indexPath];
		[delegate.navController pushViewController:savedArticle animated:YES];
		[savedArticle release];
	}
	if (indexPath.row == articles.count && self.editing) {
		AddArticleController *addArticle = [[AddArticleController alloc] init];
		[delegate.navController pushViewController:addArticle animated:YES];
		[addArticle release];
	}
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) setEditing:(BOOL)editing animated:(BOOL) animated {
	if (editing != self.editing) {
		[super setEditing:editing animated:animated];
		[tableSavedArticles setEditing:editing animated:animated];
		
		NSArray *indexes = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:articles.count inSection:0]];
		if (editing == YES) {
			[tableSavedArticles insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationLeft];
		} else {
			[tableSavedArticles deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationLeft];
		}
	}
}


- (void) tableView:(UITableView *) tv
 commitEditingStyle:(UITableViewCellEditingStyle) editing 
 forRowAtIndexPath:(NSIndexPath *) indexPath {
	if (editing == UITableViewCellEditingStyleDelete) {
		// Delete from database first
		ReadItLaterDelegate *delegate = (ReadItLaterDelegate *)[[UIApplication sharedApplication] delegate];
		Article *article = [articles objectAtIndex:indexPath.row];
		[delegate deleteArticleIdFromDatabase:article.articleId];
		// Now from the UI
		[articles removeObjectAtIndex: indexPath.row];
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
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
