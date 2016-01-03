//
//  RatingView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView {
    UIView *ratingContainer;
    UIView *changeRatingView;
}

@synthesize letters;
@synthesize icons;
@synthesize titles;

@synthesize slider;

@synthesize rate;

-(id) initWithFrame:(CGRect)frame andRating:(RatingModel *)rat {
    self = [[[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    rate = rat;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    ratingContainer = [[UIView alloc] initWithFrame:self.frame];
    changeRatingView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:ratingContainer];
    
    float yPos = self.frame.size.height / 2;
    float xPos = 0;
    float padding = yPos;
    float size = self.frame.size.height * 0.8;
    if (size > 25) {
        size = 25;
    }
    float xInc = (self.frame.size.width - (padding * 2)) / 4;
    CGRect frame = CGRectMake(0, 0, size, size);
    
    xPos += padding;
    
    UILabel *ovLabel = [[UILabel alloc] initWithFrame:frame];
    ovLabel.text = @"O";
    ovLabel.center = CGPointMake(xPos - (size / 2), yPos);
    [ratingContainer addSubview:ovLabel];
    
    UILabel *ovNumLabel = [[UILabel alloc] initWithFrame:frame];
    ovNumLabel.text = [NSString stringWithFormat:@"%ld", (long) rate.overallRating];
    ovNumLabel.center = CGPointMake(xPos + (size / 2), yPos);
    [ratingContainer addSubview:ovNumLabel];
    
    xPos += xInc;
    
    UILabel *proLabel = [[UILabel alloc] initWithFrame:frame];
    proLabel.text = @"P";
    proLabel.center = CGPointMake(xPos - (size / 2), yPos);
    [ratingContainer addSubview:proLabel];
    
    UILabel *proNumLabel = [[UILabel alloc] initWithFrame:frame];
    proNumLabel.text = [NSString stringWithFormat:@"%ld", (long) rate.proRating];
    proNumLabel.center = CGPointMake(xPos + (size / 2), yPos);
    [ratingContainer addSubview:proNumLabel];
    
    xPos += xInc;
    
    UILabel *appRating = [[UILabel alloc] initWithFrame:frame];
    appRating.text = @"P";
    appRating.center = CGPointMake(xPos - (size / 2), yPos);
    [self addSubview:appRating];
    
    UILabel *appNumRating = [[UILabel alloc] initWithFrame:frame];
    appNumRating.text = [NSString stringWithFormat:@"%ld", (long) rate.appRating];
    appNumRating.center = CGPointMake(xPos + (size / 2), yPos);
    [ratingContainer addSubview:appNumRating];
    
    xPos += xInc;
    
    UILabel *styleRating = [[UILabel alloc] initWithFrame:frame];
    styleRating.text = @"P";
    styleRating.center = CGPointMake(xPos - (size / 2), yPos);
    [ratingContainer addSubview:styleRating];
    
    UILabel *styleNumRating = [[UILabel alloc] initWithFrame:frame];
    styleNumRating.text = [NSString stringWithFormat:@"%ld", (long) rate.styleRating];
    styleNumRating.center = CGPointMake(xPos + (size / 2), yPos);
    [ratingContainer addSubview:styleNumRating];
}

-(void) userTapped:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tap locationInView:self];
        float x = location.x;
        float quarter = self.frame.size.width / 4;
        
        if ((x > 0) && (x < quarter)) {
            [self ovTapped];
            return;
        }
        if ((x > (quarter * 1)) && (x < (quarter * 2))) {
            [self proTapped];
            return;
        }
        if ((x > (quarter * 2)) && (x < (quarter * 3))) {
            [self appTapped];
            return;
        }
        if ((x > (quarter * 3)) && (x < (quarter * 4))) {
            [self styleTapped];
            return;
        }
    }
}

-(void) ovTapped {
    NSString *title = @"Overall";
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height /2);
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.center = center;
    label.alpha = 0.0;
    changeRatingView = [[UIView alloc] initWithFrame:self.frame];
    [changeRatingView addSubview:label];
    slider = [[UISlider alloc] initWithFrame:self.frame];
    slider.alpha = 0.0;
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    slider.value = rate.overallRating;
    [changeRatingView addSubview:slider];
    [self addSubview:changeRatingView];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         ratingContainer.alpha = 0.0;
                         label.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [ratingContainer removeFromSuperview];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              label.alpha = 0.0;
                                              [label removeFromSuperview];
                                              slider.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  rate.overallRating = slider.value;
                                                  [self restoreRatingContainer];
                                              });
                                          }];
                     }];
}

-(void) restoreRatingContainer {
    ratingContainer.alpha = 0.0;
    [self addSubview:ratingContainer];
    [UIView animateWithDuration:0.5
                     animations:^{
                         changeRatingView.alpha = 0.0;
                         ratingContainer.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [changeRatingView removeFromSuperview];
                         changeRatingView = nil;
                     }];
    [rate pushToServer];
}

-(void) proTapped {
    NSString *title = @"Professional";
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height /2);
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.center = center;
    label.alpha = 0.0;
    changeRatingView = [[UIView alloc] initWithFrame:self.frame];
    [changeRatingView addSubview:label];
    slider = [[UISlider alloc] initWithFrame:self.frame];
    slider.alpha = 0.0;
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    slider.value = rate.proRating;
    [changeRatingView addSubview:slider];
    [self addSubview:changeRatingView];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         ratingContainer.alpha = 0.0;
                         label.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [ratingContainer removeFromSuperview];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              label.alpha = 0.0;
                                              [label removeFromSuperview];
                                              slider.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  rate.proRating = slider.value;
                                                  [self restoreRatingContainer];
                                              });
                                          }];
                     }];
}

-(void) styleTapped {
    NSString *title = @"Style";
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height /2);
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.center = center;
    label.alpha = 0.0;
    changeRatingView = [[UIView alloc] initWithFrame:self.frame];
    [changeRatingView addSubview:label];
    slider = [[UISlider alloc] initWithFrame:self.frame];
    slider.alpha = 0.0;
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    slider.value = rate.styleRating;
    [changeRatingView addSubview:slider];
    [self addSubview:changeRatingView];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         ratingContainer.alpha = 0.0;
                         label.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [ratingContainer removeFromSuperview];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              label.alpha = 0.0;
                                              [label removeFromSuperview];
                                              slider.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  rate.styleRating = slider.value;
                                                  [self restoreRatingContainer];
                                              });
                                          }];
                     }];
}

-(void) appTapped {
    NSString *title = @"Appropriatness";
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height /2);
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.center = center;
    label.alpha = 0.0;
    changeRatingView = [[UIView alloc] initWithFrame:self.frame];
    [changeRatingView addSubview:label];
    slider = [[UISlider alloc] initWithFrame:self.frame];
    slider.alpha = 0.0;
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    slider.value = rate.appRating;
    [changeRatingView addSubview:slider];
    [self addSubview:changeRatingView];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         ratingContainer.alpha = 0.0;
                         label.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [ratingContainer removeFromSuperview];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              label.alpha = 0.0;
                                              [label removeFromSuperview];
                                              slider.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  rate.appRating = slider.value;
                                                  [self restoreRatingContainer];
                                              });
                                          }];
                     }];
}

@end
