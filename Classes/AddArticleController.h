//
//  AddArticleController.h
//  ReadItLater
//
//  Created by Student on 09/10/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddArticleController : UIViewController {
	IBOutlet UITextField	*newTitle;
	IBOutlet UITextView		*newDescription;
}

@property(nonatomic, retain) IBOutlet UITextField	*newTitle;
@property(nonatomic, retain) IBOutlet UITextView	*newDescription;

-(IBAction) saveArticleClicked:(id) sender;

@end
