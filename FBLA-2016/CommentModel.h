//
//  CommentModel.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PostModel.h"

@interface CommentModel : NSObject

@property NSInteger ID;

@property NSInteger userID;
@property UserModel *user;

@property NSInteger postID;
@property PostModel *post;

@property NSString *comment;

@end
