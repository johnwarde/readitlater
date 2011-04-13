//
//  ReadItLaterViewController.h
//  ReadItLater
//
//  Created by Student on 07/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController
	<UITableViewDataSource, UITableViewDelegate>
{
	UITableView		*tableSavedArticles;
	NSMutableArray	*articles;

}
@property (nonatomic, retain) IBOutlet UITableView *tableSavedArticles;


@end

