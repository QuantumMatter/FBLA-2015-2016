//
//  PostModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

@synthesize ID;
@synthesize userID;
@synthesize user;
@synthesize imageViews;
@synthesize images;
@synthesize frameForViews;

-(id) initWithID:(NSInteger)_ID {
    self = [super init];
    ID = _ID;
    [self loadCounterparts];
    return self;
}

-(id) initWithID:(NSInteger)_ID andFrameForView:(CGRect)frame {
    self = [self initWithID:_ID];
    [self loadViews];
    return self;
}

-(void) loadCounterparts {
    
}

-(void) loadViews {
    
}

@end
