//
//  WebArticleController.h
//  ReadItLater
//
//  Created by Student on 21/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebArticleController : UIViewController {
	NSIndexPath *index;
	
	IBOutlet UILabel	*titleLabel;
	IBOutlet UITextView *descriptionLabel;
	IBOutlet UILabel	*linkLabel;
	IBOutlet UILabel	*dateAndAuthorLabel;
	IBOutlet UILabel	*sourceLabel;
	IBOutlet UILabel	*categoryLabel;
	IBOutlet UILabel	*commentsLabel;
	
	IBOutlet UIButton *saveButton; // so that we can change the state (enable/disable)
}

@property(nonatomic, retain) IBOutlet UILabel		*titleLabel;
@property(nonatomic, retain) IBOutlet UITextView	*descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel		*linkLabel;
@property(nonatomic, retain) IBOutlet UILabel		*dateAndAuthorLabel;
@property(nonatomic, retain) IBOutlet UILabel		*sourceLabel;
@property(nonatomic, retain) IBOutlet UILabel		*categoryLabel;
@property(nonatomic, retain) IBOutlet UILabel		*commentsLabel;
@property(nonatomic, retain) IBOutlet UIButton		*saveButton;

-(id)initWithIndexPath: (NSIndexPath *)indexPath;
-(IBAction) saveArticleClicked:(id) sender;

@end
