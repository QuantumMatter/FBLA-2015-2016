//
//  TagModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/31/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "TagModel.h"
#import "ImagePostModel.h"

@implementation TagModel

@synthesize ID;
@synthesize imagePostID;
@synthesize postID;
@synthesize xPos;
@synthesize yPos;
@synthesize number;
@synthesize title;

-(id) initWithDBArray:(NSArray *)array {
    self = [super init];
    
    ID = [[array objectAtIndex:0] integerValue];
    imagePostID = [[array objectAtIndex:1] integerValue];
    
    xPos = [[array objectAtIndex:2] floatValue];
    yPos = [[array objectAtIndex:3] floatValue];
    
    number = [[array objectAtIndex:4] integerValue];
    title = [array objectAtIndex:5];
    
    [self loadComponents];
    
    return self;
}

-(void) loadComponents {
    ImagePostModel *imagePost = [[ImagePostModel alloc] initWithID:imagePostID];
    postID = imagePost.postID;
}

@end
