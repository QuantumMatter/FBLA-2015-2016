//
//  RatingModel.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"

@interface RatingModel : NSObject

@property NSInteger ID;

@property NSInteger postID;
@property PostModel *post;

@property NSInteger overallRating;
@property NSInteger proRating;
@property NSInteger styleRating;
@property NSInteger appRating;

@end
