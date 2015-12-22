//
//  SlidingViewController.h
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidingViewDelegate <NSObject>

-(NSInteger)numberOfViewsInSlidingView:(UIView *)slidingView;
-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView;
-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView;

@end

@interface SlidingViewController : UIView

-(id) initWithDelegate:(id<SlidingViewDelegate>)del;
-(id) initWithFrame:(CGRect)frame andDelegate:(id<SlidingViewDelegate>)del;

@property id<SlidingViewDelegate> delegate;

@property NSMutableArray *titles;
@property NSMutableArray *views;
@property NSInteger numberOfViews;
@property NSInteger selectedView;

-(void) swiped:(UIPanGestureRecognizer *)swipe;

@end
