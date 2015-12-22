//
//  FirstViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "LoginViewController.h"
#import "SlidingViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SlidingViewController *sliding = [[SlidingViewController alloc] initWithFrame:CGRectMake(0, 0, 375, 375) andDelegate:self];
    [self.view addSubview:sliding];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:sliding action:@selector(swiped:)];
    [self.view addGestureRecognizer:tap];
}

-(void) recognized:(UISwipeGestureRecognizer *)recog {
    //NSLog(@"Recognized");
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    switch (index) {
        case 0:
            return @"Test 01";
            break;
            
        case 1:
            return @"Test 02";
            break;
            
        case 2:
            return @"Test 03";
            break;
            
        default:
            return @"Out of Range";
            break;
    }
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return 3;
}

-(UIView *)viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    switch (index) {
        case 0:
            view.backgroundColor = [UIColor grayColor];
            break;
            
        case 1:
            view.backgroundColor = [UIColor greenColor];
            break;
            
        case 2:
            view.backgroundColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
