//
//  ImagePostModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "ImagePostModel.h"

@implementation ImagePostModel

@synthesize ID;
@synthesize intType;
@synthesize type;
@synthesize images;
@synthesize postID;
@synthesize post;
@synthesize view;

-(id) initWithID:(NSInteger)_ID {
    self = [super init];
    ID = _ID;
    [self loadCounterparts];
    return self;
}

-(id) initWithID:(NSInteger)_ID andFrame:(CGRect)frame {
    self = [self initWithID:_ID];
    [self loadComponents:frame];
    return self;
}

-(void) loadCounterparts {
    
}

-(void) loadComponents:(CGRect)frame {
    view = [[UIView alloc] initWithFrame:frame];
    switch (type) {
        case onePic:
            [self loadOnePic];
            break;
            
        case twoPic:
            [self loadTwoPic];
            break;
        
        case threePic:
            [self loadThreePic];
            break;
            
        default:
            break;
    }
}

-(void) loadOnePic {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.frame];
    imageView.image = [images objectAtIndex:0];
    [view addSubview:imageView];
}

-(void) loadTwoPic {
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    
    float halfWidth = width / 2;
    float halfHeight = height / 2;
    
    UIImageView *first = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, halfWidth, height)];
    first.image = [images objectAtIndex:0];
    [view addSubview:first];
    
    UIImageView *second = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, 0, halfWidth, height)];
    second.image = [images objectAtIndex:1];
    [view addSubview:second];
}

-(void) loadThreePic {
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    
    float halfWidth = width / 2;
    float halfHeight = height / 2;
    
    UIImageView *first = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, halfWidth, height)];
    first.image = [images objectAtIndex:0];
    [view addSubview:first];
    
    UIImageView *second = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, 0, halfWidth, halfHeight)];
    second.image = [images objectAtIndex:1];
    [view addSubview:second];
    
    UIImageView *third = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight)];
    third.image = [images objectAtIndex:2];
    [view addSubview:third];
}

@end
