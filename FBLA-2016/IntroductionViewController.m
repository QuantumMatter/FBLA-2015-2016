//
//  IntroductionViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "IntroductionViewController.h"
#import "SlidingViewController.h"
#import "SignInMenuView.h"
#import "UserModel.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController {
    SlidingViewController *slidingView;
    SignInMenuView *signInMenu;
    
    NSString *docPath;
    
    NSArray *introViews;
    
    UserModel *currUser;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currUser = [self data];
    if (currUser != nil) {
        NSLog(@"User Already Exists");
        [self performSegueWithIdentifier:@"presentHome" sender:self];
        return;
    }
    
    introViews = [[NSBundle mainBundle] loadNibNamed:@"IntroViews" owner:self options:nil];
    
    slidingView = [[SlidingViewController alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:slidingView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:slidingView action:@selector(swiped:)];
    [self.view addGestureRecognizer:pan];
    
    signInMenu = [[SignInMenuView alloc] init];
    signInMenu.frame = CGRectMake(0, 0.9 * self.view.frame.size.height, self.view.frame.size.width, 0.1 * self.view.frame.size.height);
    [signInMenu.signInButton addTarget:self action:@selector(signInPressed:) forControlEvents:UIControlEventTouchUpInside];
    [signInMenu.registerButton addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInMenu];
}

-(void) viewDidAppear:(BOOL)animated {
    if (currUser != nil) {
        [self performSegueWithIdentifier:@"presentHome" sender:self];
    }
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [introViews objectAtIndex:index];
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    NSString *title;
    switch (index) {
        case 0:
            title = @"WELCOME!";
            break;
            
        case 1:
            title = @"EXPLORE";
            break;
            
        case 2:
            title = @"JOIN";
            break;
            
        default:
            title = @"ERROR";
            break;
    }
    return title;
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return 3;
}

-(void) signInPressed:(UIButton *) button {
    NSLog(@"Sign In Pressed");
    [self performSegueWithIdentifier:@"presentSignIn" sender:self];
}

-(void) registerPressed:(UIButton *) button {
    NSLog(@"Register Pressed");
    [self performSegueWithIdentifier:@"presentRegister" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UserModel *) data {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    UserModel *save = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return save;
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
