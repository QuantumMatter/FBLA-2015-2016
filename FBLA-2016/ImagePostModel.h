//
//  ImagePostModel.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

@interface ImagePostModel : NSObject

@property NSInteger ID;

typedef enum  ImagePostType {
    onePic,
    twoPic,
    threePic,
}ImagePostType;

@property NSInteger intType;
@property ImagePostType type;

@property NSMutableArray *images;

@property NSInteger *postID;
@property PostModel *post;

@property UIView *view;

-(id) initWithID:(NSInteger)_ID;
-(id) initWithID:(NSInteger)_ID andFrame:(CGRect)frame;

@end
