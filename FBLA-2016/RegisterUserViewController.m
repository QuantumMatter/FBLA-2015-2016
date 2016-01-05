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
    
    NSString *docPath;
    
    NSURLConnection *uploadConn;
    NSString *imagePath;
    
    NSString *password;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

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
    NSInteger gender = personalView.genderControl.selectedSegmentIndex;
    if (gender == 0) {
        newUser.gender = @"Male";
    } else {
        newUser.gender = @"Female";
    }
    
    newUser.firstName = personalView.firstName.text;
    newUser.lastName = personalView.lastName.text;
    newUser.email = personalView.emailAddress.text;
    
    newUser.latitude = friendsView.location.coordinate.latitude;
    newUser.longitude = friendsView.location.coordinate.longitude;
    newUser.zipCode = 80234;
    
    newUser.followers = 0;
    newUser.following = 0;
    
    password = personalView.password.text;
    
    [self uploadimage:UIImageJPEGRepresentation(personalView.profilePic.image, 0.1)];
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return 3;
}

-(void) saveNewUser {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //NSMutableData *_data = [[NSMutableData alloc] init];
    [archiver encodeObject:newUser forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
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
    /*newUser.ID = newID;
    
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
    
    [self saveNewUser];*/
    [self performSegueWithIdentifier:@"presentHome" sender:self];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(dataString);
    if (connection == uploadConn) {
        NSArray *comp = [dataString componentsSeparatedByString:@"\\"];
        imagePath = [NSString stringWithFormat:@"http://24.8.58.134/FocalPoint/Images/%@.jpg", [comp lastObject]];
        [self uploadUser];
    }
}

-(void) uploadUser {
    NSString *dataString = [NSString stringWithFormat:@"Email=%@&Firstname=%@&Followers=%ld&Following=%ld&Gender=%@&LastName=%@&Latitude=%f&Longitude=%f&Password=%@&ProfilePic=%@&ZipCode=%ld", newUser.email, newUser.firstName, (long)newUser.followers, (long)newUser.following, newUser.gender, newUser.lastName, newUser.latitude, newUser.longitude, password, imagePath, (long)newUser.zipCode];
    NSURL *URL = [NSURL URLWithString:@"http://24.8.58.134/FocalPoint/API/UsersAPI/"];
    NSMutableURLRequest *request = [self postRequestFor:URL withDataString:dataString];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [self saveNewUser];
    [self performSegueWithIdentifier:@"presentHome" sender:self];
}

-(NSMutableURLRequest *) postRequestFor:(NSURL *)url withDataString:(NSString *)string {
    NSData *postData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init ];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return request;
}

-(void) uploadimage:(NSData *)imageData {
    NSString *urlString = @"http://24.8.58.134/FocalPoint/API/Upload";
    NSString *filename = @"filename";
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    uploadConn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
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
