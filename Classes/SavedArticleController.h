//
//  SavedArticleController.h
//  ReadItLater
//
//  Created by Student on 14/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedArticleController : UIViewController {
	NSIndexPath *index;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *linkLabel;
	IBOutlet UILabel *dateAndAuthorLabel;
	IBOutlet UILabel *sourceLabel;
	IBOutlet UILabel *categoryLabel;
	IBOutlet UILabel *commentsLabel;
}

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel *linkLabel;
@property(nonatomic, retain) IBOutlet UILabel *dateAndAuthorLabel;
@property(nonatomic, retain) IBOutlet UILabel *sourceLabel;
@property(nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property(nonatomic, retain) IBOutlet UILabel *commentsLabel;

-(id)initWithIndexPath: (NSIndexPath *)indexPath;

@end
