//
//  SlidingViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "SlidingViewController.h"
#import "PopularPeopleView.h"

@implementation SlidingViewController {
    
    NSInteger secondaryUnderLength;
    NSInteger secondaryUnderSpacing;
    NSInteger primaryUnderLength;
    
    CGRect leftFrame;
    CGRect currentFrame;
    CGRect rightFrame;
    
    CGPoint initPoint;
    
    NSMutableArray *unders;
    NSMutableArray *labels;
    
    BOOL active;
}

@synthesize views;
@synthesize titles;
@synthesize numberOfViews;
@synthesize delegate;
@synthesize selectedView;

-(id) initWithDelegate:(id<SlidingViewDelegate>)del{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SlidingView" owner:self options:nil] objectAtIndex:0];
    delegate = del;
    selectedView = 0;
    
    views = [[NSMutableArray alloc] init];
    titles = [[NSMutableArray alloc] init];
    
    unders = [[NSMutableArray alloc] init];
    labels = [[NSMutableArray alloc] init];
    
    numberOfViews = [delegate numberOfViewsInSlidingView:self];
    for (NSInteger i = 0; i < numberOfViews; i++) {
        [views addObject:[delegate viewForIndex:i forSlidingView:self]];
    }
    for (NSInteger i = 0; i < numberOfViews; i++) {
        [titles addObject:[delegate titleForIndex:i forSlidingView:self]];
    }
    
    leftFrame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    currentFrame = self.frame;
    rightFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    //[self loadComponents];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame andDelegate:(id<SlidingViewDelegate>)del {
    self = [self initWithDelegate:del];
    self.frame = frame;
    
    leftFrame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    currentFrame = self.frame;
    rightFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    [self loadComponents];
    
    return self;
}

-(void) loadComponents {
    currentFrame = CGRectMake(0, 0, currentFrame.size.width, currentFrame.size.height);
    
    active = YES;
    
    secondaryUnderSpacing = 10;
    secondaryUnderLength = 25;
    primaryUnderLength = self.frame.size.width - (numberOfViews * (secondaryUnderLength + secondaryUnderSpacing));
    
    for (int i = 0; i < numberOfViews; i++) {
        NSInteger xPos = 8 + (i * (secondaryUnderLength + secondaryUnderSpacing));
        UIView *under = [[UIView alloc] initWithFrame:CGRectMake(xPos, 55, secondaryUnderLength, 8)];
        [unders addObject:under];
        [self addSubview:under];
        under.layer.zPosition = 70;
        under.backgroundColor = [UIColor whiteColor];
        
        xPos = 8 + (0.8 * i * self.frame.size.width);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 8, self.frame.size.width / 2, 47)];
        label.text = [titles objectAtIndex:i];
        [labels addObject:label];
        [self addSubview:label];
        label.layer.zPosition = 70;
        label.font = [label.font fontWithSize:30];
        label.textColor = [UIColor whiteColor];
    }
    
    UIView *viewU = [unders objectAtIndex:0];
    viewU.frame = CGRectMake(viewU.frame.origin.x, viewU.frame.origin.y, primaryUnderLength, viewU.frame.size.height);
    for (int i = 1; i < [unders count]; i++) {
        UIView *view = [unders objectAtIndex:i];
        view.frame = CGRectMake(view.frame.origin.x + primaryUnderLength, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
    
    for (int i = 0; i < [views count]; i++) {
        UIView *view = [views objectAtIndex:i];
        view.frame = rightFrame;
        view.layer.zPosition = 20;
        [self addSubview:view];
    }
    [UIView animateWithDuration:1.0f animations:^{
        UIView *view = [views objectAtIndex:0];
        view.frame = currentFrame;
    }];
    
    UIView *leftButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, 65)];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeft:)];
    //leftButton.backgroundColor = [UIColor blackColor];
    [leftButton addGestureRecognizer:leftTap];
    [self addSubview:leftButton];
    leftButton.layer.zPosition = 80;
    
    UIView *rightButton = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, 65)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRight:)];
    //rightButton.backgroundColor = [UIColor blueColor];
    [rightButton addGestureRecognizer:rightTap];
    [self addSubview:rightButton];
    rightButton.layer.zPosition = 80;
}

-(void) tapLeft:(UITapGestureRecognizer *)recog {
    NSLog(@"Tap Left");
    [self decreaseSelectedIndex];
}

-(void) tapRight:(UITapGestureRecognizer *)recog {
    NSLog(@"Tap Right");
    [self increaseSelectedIndex];
}

-(void) swiped:(UIPanGestureRecognizer *)recog {
    if (active) {
        switch (recog.state) {
            case UIGestureRecognizerStateBegan:
            {
                initPoint = [recog locationInView:self];
                break;
            }
                
            case UIGestureRecognizerStateEnded:
            {
                CGPoint point = [recog locationInView:self];
                double deltaX = point.x - initPoint.x;
                if (fabs(deltaX) > 50) {
                    if (deltaX < 0) {
                        [self increaseSelectedIndex];
                    } else {
                        [self decreaseSelectedIndex];
                    }
                } else {
                    [self restoreView:deltaX];
                }
                return;
                break;
            }
                
            default:
                break;
        }
        CGPoint point = [recog locationInView:self];
        double deltaX = point.x - initPoint.x;
        UIView *viewA = [views objectAtIndex:selectedView];
        UIView *viewB;
        CGRect rectA;
        CGRect rectB;
        if (deltaX <= 0) {
            if ((selectedView + 1) == numberOfViews) {
                return;
            }
            viewB = [views objectAtIndex:(selectedView+1)];
            rectB = CGRectMake(self.frame.size.width + deltaX, 0, self.frame.size.width, self.frame.size.height);
        } else {
            if (selectedView == 0) {
                return;
            }
            viewB = [views objectAtIndex:(selectedView-1)];
            rectB = CGRectMake((0 - self.frame.size.width) + deltaX, 0, self.frame.size.width, self.frame.size.height);
        }
        rectA = CGRectMake(deltaX, 0, self.frame.size.width, self.frame.size.height);
        viewA.frame = rectA;
        viewB.frame = rectB;
    }
}

-(void) restoreView:(float)deltaX {
    UIView *viewA = [views objectAtIndex:selectedView];
    UIView *viewB;
    CGRect rectA;
    CGRect rectB;
    if (deltaX <= 0) {
        if ((selectedView + 1) == numberOfViews) {
            return;
        }
        viewB = [views objectAtIndex:(selectedView+1)];
        rectB = rightFrame;
    } else {
        if (selectedView == 0) {
            return;
        }
        viewB = [views objectAtIndex:(selectedView-1)];
        rectB = leftFrame;
    }
    rectA = currentFrame;
    [UIView animateWithDuration:0.25 animations:^{
        viewA.frame = rectA;
        viewB.frame = rectB;
    }];
}

-(void) decreaseSelectedIndex {
    [self endEditing:YES];
    UIView *viewA = [views objectAtIndex:selectedView];
    UILabel *labelA = [labels objectAtIndex:selectedView];
    UIView *underA = [unders objectAtIndex:selectedView];
    
    if (selectedView == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            viewA.frame = currentFrame;
        }];
        return;
    }
    
    UIView *viewB = [views objectAtIndex:(selectedView - 1)];
    UILabel *labelB = [labels objectAtIndex:(selectedView - 1)];
    UIView *underB = [unders objectAtIndex:(selectedView - 1)];
    
    UILabel *labelC;
    if ((selectedView + 2) > (numberOfViews - 0)) {
        labelC = nil;
    } else {
        labelC = [labels objectAtIndex:(selectedView + 1)];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        viewA.frame = rightFrame;
        viewB.frame = currentFrame;
        
        labelB.frame = labelA.frame;
        labelA.frame = CGRectMake((0.8 * self.frame.size.width), labelA.frame.origin.y, labelA.frame.size.width, labelA.frame.size.height);
        
        underB.frame = CGRectMake(underB.frame.origin.x, underB.frame.origin.y, primaryUnderLength, underB.frame.size.height);
        underA.frame = CGRectMake(underB.frame.origin.x + underB.frame.size.width + secondaryUnderSpacing, underA.frame.origin.y, secondaryUnderLength, underA.frame.size.height);
        
        if (labelC != nil) {
            labelC.frame = CGRectMake(self.frame.size.width + 50, labelC.frame.origin.y, labelC.frame.size.width, labelC.frame.size.height);
        }
        @try {
            PopularPeopleView *viewP = (PopularPeopleView *)viewA;
            [viewP deactivateView];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    active = YES;
    selectedView--;
}

-(void) increaseSelectedIndex {
    [self endEditing:YES];
    UIView *viewA = [views objectAtIndex:selectedView];
    UILabel *labelA = [labels objectAtIndex:selectedView];
    UIView *underA = [unders objectAtIndex:selectedView];
    
    if ((selectedView+1) == numberOfViews) {
        [UIView animateWithDuration:0.5 animations:^{
            viewA.frame = currentFrame;
        }];
        return;
    }
    UIView *viewB = [views objectAtIndex:(selectedView + 1)];
    UILabel *labelB = [labels objectAtIndex:(selectedView + 1)];
    UIView *underB = [unders objectAtIndex:(selectedView + 1)];
    
    UILabel *labelC;
    if ((selectedView + 2) > (numberOfViews - 1)) {
        labelC = nil;
    } else {
        labelC = [labels objectAtIndex:(selectedView + 2)];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        viewA.frame = leftFrame;
        viewB.frame = currentFrame;
        
        labelB.frame = labelA.frame;
        labelA.frame = CGRectMake((0 - labelA.frame.size.width), labelA.frame.origin.y, labelA.frame.size.width, labelA.frame.size.height);
        
        underB.frame = CGRectMake(underA.frame.origin.x + secondaryUnderLength + secondaryUnderSpacing, underB.frame.origin.y, primaryUnderLength, underB.frame.size.height);
        underA.frame = CGRectMake(8 + (selectedView * (secondaryUnderSpacing + secondaryUnderLength)), underA.frame.origin.y, secondaryUnderLength, underB.frame.size.height);
        
        if (labelC != nil) {
            labelC.frame = CGRectMake(0.8 * self.frame.size.width, labelC.frame.origin.y, labelC.frame.size.width, labelC.frame.size.height);
        }
    } completion:^(BOOL finished) {
        @try {
            PopularPeopleView *viewP = (PopularPeopleView *)viewB;
            [viewP activateView];
            active = NO;
        }
        @catch (NSException *exception) {
            active = YES;
        }
        @finally {
            
        }
    }];
    selectedView++;
}

@end
