//
//  WebArticlesController.h
//  ReadItLater
//
//  Created by Student on 15/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebArticlesController : UIViewController {
	NSMutableData *feedContent;
	IBOutlet UIActivityIndicatorView *waitIcon;
}
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *waitIcon;

- (IBAction) refreshFeedClicked:(id) sender;
- (void)startFeedRefresh;

@end
