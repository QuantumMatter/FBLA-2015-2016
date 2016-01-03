//
//  MeViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "MeViewController.h"
#import "SlidingViewController.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileView.h"

@interface MeViewController ()

@end

@implementation MeViewController {
    NSString *docPath;
    
    UserModel *user;
    
    SlidingViewController *slidingView;
    
    UIView *myPostsView;
    UIView *myCommentsView;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [self getCurrentUser];
    ProfileView *profileView = [[ProfileView alloc] initWithFrame:self.view.frame andUser:user.ID];
    [self.view addSubview:profileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UserModel *) getCurrentUser {
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

- (IBAction)signOut:(id)sender {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:docPath error:&error];
    if (success) {
        [self performSegueWithIdentifier:@"presentIntroduction" sender:self];
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
