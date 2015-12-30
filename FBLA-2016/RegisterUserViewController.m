//
//  RegisterUserViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "PersonalInfoView.h"
#import "SlidingViewController.h"
#import "FindFriendsView.h"
#import "PopularPeopleView.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController {
    SlidingViewController *slidingView;
    
    PersonalInfoView *personalView;
    FindFriendsView *friendsView;
    PopularPeopleView *popularView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    personalView = [[PersonalInfoView alloc] initWithViewAndFrame:self.view.frame];
    personalView.parentController = self;
    friendsView = [[FindFriendsView alloc] initWithFrame:self.view.frame];
    popularView = [[PopularPeopleView alloc] initWithFrame:self.view.frame];
    
    slidingView = [[SlidingViewController alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:slidingView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:slidingView action:@selector(swiped:)];
    [pan addTarget:personalView action:@selector(userSwiped:)];
    [pan addTarget:popularView action:@selector(userSwiped:)];
    [self.view addGestureRecognizer:pan];
    
    // Do any additional setup after loading the view.
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return 3;
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    NSString *title = @"";
    switch (index) {
        case 0:
            title = @"Information";
            break;
            
        case 1:
            title = @"Find Friends";
            break;
            
        case 2:
            title = @"Personalize";
            break;
            
        default:
            title = @"Error";
            break;
    }
    return title;
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    UIView *view;
    switch (index) {
        case 0:
            view = personalView;
            break;
            
        case 1:
            view = friendsView;
            break;
            
        case 2:
            view = popularView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
