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
#import "UserModel.h"
#import "FriendModel.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController {
    SlidingViewController *slidingView;
    
    PersonalInfoView *personalView;
    FindFriendsView *friendsView;
    PopularPeopleView *popularView;
    
    UILabel *goLabel;
    
    UserModel *newUser;
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
    
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect frame = CGRectMake(0.75 * width, 0.85 * height, 0.2 * width, 0.1 * height);
    UIView *labelContainer = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:labelContainer];
    goLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    goLabel.text = @"GO";
    goLabel.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *goTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLabelPressed)];
    [labelContainer addGestureRecognizer:goTap];
    [labelContainer addSubview:goLabel];
    //goLabel.layer.zPosition = 100;
}

-(void) goLabelPressed {
    NSLog(@"Go Pressed");
    
    newUser = [[UserModel alloc] init];
    newUser.ID = -1;
    newUser.profilePic = personalView.profilePic.image;
    
    newUser.firstName = personalView.firstName.text;
    newUser.lastName = personalView.lastName.text;
    newUser.email = personalView.emailAddress.text;
    
    newUser.latitude = friendsView.location.coordinate.latitude;
    newUser.longitude = friendsView.location.coordinate.longitude;
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

-(void) user:(id)sender receivedNewID:(NSInteger)newID {
    newUser.ID = newID;
    
    newUser.followers = 0;
    newUser.following = 0;
    
    NSMutableArray *newFriends = [[NSMutableArray alloc] init];
    newFriends = friendsView.nFriends;
    
    for (int i = 0; i < [newFriends count]; i++) {
        newUser.following++;
        
        UserModel *friendUser = [newFriends objectAtIndex:i];
        
        FriendModel *friend = [[FriendModel alloc] initWithUser:newID andFriend:friendUser.ID];
        [friend pushToServer];
    }
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
