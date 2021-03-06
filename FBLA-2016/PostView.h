//
//  PostView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostModel.h"
#import "SlidingViewController.h"

@interface PostView : UIView <SlidingViewDelegate>

-(id) initWithFrame:(CGRect)frame andPost:(PostModel *)postModel;

@end
