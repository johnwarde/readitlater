//
//  Article.m
//  ReadItLater
//
//  Created by Student on 12/04/2011.
//  Copyright 2011 SOC. All rights reserved.
//

#import "Article.h"


@implementation Article

@synthesize title;
@synthesize description;
@synthesize link;
@synthesize pubdate;
@synthesize author;
@synthesize category;
@synthesize comments;
@synthesize guid;
@synthesize source;
@synthesize read;
@synthesize deleted;


-(void) dealloc {
	[title release];
	[description release];
	[link release];
	[pubdate release];
	[author release];
	[category release];
	[comments release];
	[guid release];
	[source release];
	[read release];
	[deleted release];
	[super dealloc];
}

@end
