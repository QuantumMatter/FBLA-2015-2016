//
//  ImagePostView.h
//  FBLA-2016
//
//  Created by David Kopala on 1/1/16.
//  Copyright © 2016 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePostModel.h"

@protocol ImagePostDelegate <NSObject>

-(void) userSelectedImage:(UIImageView *)view;

@end

@interface ImagePostView : UIView

-(id) initWithFrame:(CGRect)frame andModel:(ImagePostModel *)model;

-(id) initWithFrame:(CGRect)frame forNewPost:(NSInteger)count;

@property id<ImagePostDelegate> delegate;

-(UIImageView *) imageForTap:(UITapGestureRecognizer *)tap;

@property NSMutableArray *imageViews;

@end
