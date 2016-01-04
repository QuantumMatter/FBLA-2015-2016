//
//  PostModel.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface PostModel : NSObject

@property NSInteger ID;

@property NSInteger userID;
@property UserModel *user;

@property NSMutableArray *images;

@property NSMutableArray *imageViews;

@property CGRect *frameForViews;

@property NSString *datePosted;

-(id) initWithID:(NSInteger)_ID andFrameForView:(CGRect)frame;
-(id) initWithID:(NSInteger)_ID;

-(id) initWithPostArray:(NSArray *)array;

-(id) initWithDBData:(NSData *)data;

@end
