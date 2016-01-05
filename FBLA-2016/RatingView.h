//
//  RatingView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingModel.h"

@interface RatingView : UIView <UIGestureRecognizerDelegate>

@property NSMutableArray *letters;
@property NSMutableArray *icons;
@property NSMutableArray *titles;

@property UISlider *slider;

@property RatingModel *rate;

-(id) initWithFrame:(CGRect)frame andRating:(RatingModel *)rat;

-(void) tapped:(UITapGestureRecognizer *)tap;

@end
