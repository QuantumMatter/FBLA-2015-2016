//
//  ProfileView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"
#import "PostCellView.h"

@interface ProfileView : UIView <SlidingViewDelegate, PostCellDelegate>

-(id) initWithFrame:(CGRect)frame andUser:(NSInteger)uID;

@property UIViewController *parentController;

@end
