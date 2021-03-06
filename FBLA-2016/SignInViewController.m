//
//  SignInViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "SignInViewController.h"
#import "UserModel.h"
#import "DBManager.h"

@interface SignInViewController ()

@end

@implementation SignInViewController {
    NSString *docPath;
    
    DBManager *manager;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@synthesize appIconView;
@synthesize emailField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signInPressed:(id)sender {
    UserModel *saveTest = [[UserModel alloc] init];
    [saveTest test1];
    
    [self checkUser];
}

-(void) checkUser {
    manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    NSString *email = emailField.text;
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM users WHERE Email like \"%@\"", email]];
    if (!([array count] > 0)) {
        [self badUser];
        return;
    }
    UserModel *temp = [[UserModel alloc] initWithDBArray:[array objectAtIndex:0]];
    
    NSString *pass = passwordField.text;
    array = [array objectAtIndex:0];
    if ([pass isEqualToString:[array objectAtIndex:11]]) {
        [self userOK:temp];
    } else {
        [self badUser];
    }
}

-(void) badUser {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Login"
                                                    message:@"Incorrect Email or Password"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) userOK:(UserModel *)user {
    //[manager executeQuery:@"UPDATE users SET Password=\"\""];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //NSMutableData *_data = [[NSMutableData alloc] init];
    [archiver encodeObject:user forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [self performSegueWithIdentifier:@"presentHome" sender:self];
}

- (IBAction)registerPressed:(id)sender {
    [self performSegueWithIdentifier:@"presentRegister" sender:self];
}

@end
