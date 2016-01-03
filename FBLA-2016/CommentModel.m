//
//  CommentModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

@synthesize ID;
@synthesize userID;
@synthesize user;
@synthesize postID;
@synthesize post;
@synthesize comment;

-(id) initWithDBArray:(NSArray *)array {
    self = [super init];
    
    if ([array count] == 1) {
        array = [array objectAtIndex:0];
    }
    
    ID = [[array objectAtIndex:0] integerValue];
    userID = [[array objectAtIndex:1] integerValue];
    postID = [[array objectAtIndex:2] integerValue];
    
    comment = [array objectAtIndex:3];
    
    [self loadComponents];
    
    return self;
}

-(void) loadComponents {
    user = [[UserModel alloc] initWithID:userID];
    post = [[PostModel alloc] initWithID:postID];
}

@end
