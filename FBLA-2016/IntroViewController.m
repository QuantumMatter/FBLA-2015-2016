//
//  IntroViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "IntroViewController.h"
#import "SlidingViewController.h"

#import "PostCellView.h"
#import "PostModel.h"

@interface IntroViewController ()

@end

@implementation IntroViewController {
    NSArray *nibArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    
    nibArray = [[NSBundle mainBundle] loadNibNamed:@"IntroViews" owner:self options:nil];
    for (int i = 0; i < [nibArray count]; i++) {
        UIView *view = [nibArray objectAtIndex:i];
        view.frame = self.view.frame;
        view.clipsToBounds = YES;
    }
    
    SlidingViewController *slidingView = [[SlidingViewController alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:slidingView];
    slidingView.clipsToBounds = YES;
    
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
