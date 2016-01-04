//
//  RatingModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "RatingModel.h"

@implementation RatingModel

@synthesize ID;
@synthesize postID;
@synthesize post;

@synthesize overallRating;
@synthesize proRating;
@synthesize styleRating;
@synthesize appRating;

-(void) pushToServer {
    
}

-(id) initWithDBArray:(NSArray *)array {
    self = [super init];
    
    if ([array count] == 1) {
        array = [array objectAtIndex:0];
    }
    
    if ([array count] == 0) {
        ID = -3;
        postID = -3;
        
        overallRating = 5;
        proRating = 5;
        styleRating = 5;
        appRating = 5;
        return self;
    }
    
    ID = [[array objectAtIndex:0] integerValue];
    postID = [[array objectAtIndex:1] integerValue];
    
    overallRating = [[array objectAtIndex:2] integerValue];
    proRating = [[array objectAtIndex:3] integerValue];
    styleRating = [[array objectAtIndex:4] integerValue];
    appRating = [[array objectAtIndex:5] integerValue];
    
    return self;
}

@end
