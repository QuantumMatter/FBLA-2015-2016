//
//  IntroViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "IntroViewController.h"
#import "SlidingViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController {
    NSArray *nibArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nibArray = [[NSBundle mainBundle] loadNibNamed:@"IntroViews" owner:self options:nil];
    
    SlidingViewController *slidingView = [[SlidingViewController alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:slidingView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:slidingView action:@selector(swiped:)];
    [self.view addGestureRecognizer:pan];
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return [nibArray count];
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [NSString stringWithFormat:@"Slide #%ld", (long)index+1];
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [nibArray objectAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
