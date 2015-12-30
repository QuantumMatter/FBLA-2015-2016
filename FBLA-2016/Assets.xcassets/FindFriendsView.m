//
//  FindFriendsView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "FindFriendsView.h"
#import <CoreLocation/CoreLocation.h>
#import "UserModel.h"
#import "ProfilePanelView.h"

@implementation FindFriendsView {
    CLLocationManager *locationManager;
    
    float scrollHeight;
    float scrollSpacing;
    
    NSMutableArray *allUsers;
    NSMutableArray *nearbyUsers;
    NSMutableArray *bluetoothUsers;
    NSMutableArray *emailUsers;
    
    NSInteger lowZip;
    NSInteger highZip;
    NSInteger zip;
}

@synthesize scrollView;

@synthesize nearbyTitle;
@synthesize byLocationTitle;
@synthesize nearbyScroll;

@synthesize bluetoothTitle;
@synthesize bluetoothScroll;

@synthesize emailTitle;
@synthesize emailScroll;
@synthesize emailField;

-(id) initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"RegisterViews" owner:self options:nil] objectAtIndex:1];
    self.frame = frame;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // Check for iOS 8 Vs earlier version like iOS7.Otherwise code will
    // crash on ios 7
    if ([locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    float yPos = 65;
    float spacing = self.frame.size.height / 20;
    float titleHeight = spacing * 2;
    float secondaryHeight = titleHeight / 2;
    scrollHeight = 150;//self.frame.size.height * 3 / 20;
    scrollSpacing = scrollHeight / 3;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview: scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSwiped:)];
    [scrollView addGestureRecognizer:tap];
    
    nearbyTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, titleHeight)];
    nearbyTitle.text = @"Find Friends Nearby";
    [scrollView addSubview:nearbyTitle];
    yPos += nearbyTitle.frame.size.height;
    
    byLocationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, secondaryHeight)];
    byLocationTitle.text = @"By Location";
    [scrollView addSubview:byLocationTitle];
    yPos += byLocationTitle.frame.size.height;
    
    nearbyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, scrollHeight)];
    [scrollView addSubview:nearbyScroll];
    yPos += nearbyScroll.frame.size.height;
    
    yPos += spacing;
    
    bluetoothTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, secondaryHeight)];
    bluetoothTitle.text = @"By Bluetooth";
    [scrollView addSubview:bluetoothTitle];
    yPos += bluetoothTitle.frame.size.height;
    
    bluetoothScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, scrollHeight)];
    [scrollView addSubview:bluetoothScroll];
    yPos += bluetoothScroll.frame.size.height;
    
    yPos += spacing;
    
    emailTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, titleHeight)];
    emailTitle.text = @"Find Friends By Email";
    [scrollView addSubview:emailTitle];
    yPos += emailTitle.frame.size.height;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, titleHeight)];
    emailField.placeholder = @"Email Address";
    emailField.delegate = self;
    [scrollView addSubview:emailField];
    yPos += emailField.frame.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustViewForKeyboard)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    emailScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, scrollHeight)];
    [scrollView addSubview:emailScroll];
    yPos += emailScroll.frame.size.height;
    
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    allUsers = [[NSMutableArray alloc] init];
    nearbyUsers = [[NSMutableArray alloc] init];
    bluetoothUsers = [[NSMutableArray alloc] init];
    emailUsers = [[NSMutableArray alloc] init];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        zip = [placemark.postalCode integerValue];
        [self loadNearbyUsers];
    }];
}

-(void) loadNearbyUsers {
    NSInteger zipTolerance = 450;
    lowZip = zip - zipTolerance;
    highZip = zip + zipTolerance;
    
    UserModel *user1 = [[UserModel alloc] init];
    [user1 test1];
    user1.delegate = self;
    [allUsers addObject:user1];
    
    UserModel *user2 = [[UserModel alloc] init];
    user2.delegate = self;
    [user2 test2];
    [allUsers addObject:user2];
    
    UserModel *user3 = [[UserModel alloc] init];
    user3.delegate = self;
    [user3 test3];
    [allUsers addObject:user3];
    
    UserModel *user4 = [[UserModel alloc] init];
    user4.delegate = self;
    [user4 test4];
    [allUsers addObject:user4];
}

-(void) zipFound:(id)sender {
    [self addUserToNearby:sender];
}

-(void) addUserToNearby:(UserModel *)tempUser {
    NSInteger userZip = tempUser.zipCode;
    if ((userZip > lowZip) && (userZip < highZip)) {
        [nearbyUsers addObject:tempUser];
    }
    
    NSArray *sortedArray = [nearbyUsers sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UserModel *userA = (UserModel *)obj1;
        double distanceA = [self distanceToLocation:userA.location];
        
        UserModel *userB = (UserModel *)obj2;
        double distanceB = [self distanceToLocation:userB.location];
        
        NSDate *dateB = [[NSDate alloc] initWithTimeIntervalSince1970:distanceB];
        NSDate *dateA = [[NSDate alloc] initWithTimeIntervalSince1970:distanceA];
        
        return [dateA compare:dateB];
    }];
    
    for (int i = 0; i < [sortedArray count]; i++) {
        ProfilePanelView *profilePanel = [[ProfilePanelView alloc] initWithUser:[sortedArray objectAtIndex:i]];
        profilePanel.frame = CGRectMake(i * (scrollHeight + scrollSpacing), 0, scrollHeight, scrollHeight);
        [nearbyScroll addSubview:profilePanel];
        nearbyScroll.contentSize = CGSizeMake((i + 1) * (scrollHeight + scrollSpacing), scrollHeight);
    }
}

-(double) distanceToLocation:(CLLocation *)locationB {
    return [locationManager.location distanceFromLocation:locationB];
}

-(void) adjustViewForKeyboard {
    if (emailField.isEditing) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, -216, self.frame.size.width, self.frame.size.height);
        }];
    }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == emailField) {
        NSString *finalString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        [self emailChanged:finalString];
    }
    return YES;
}

-(void) emailChanged:(NSString *)text {
    emailUsers = nil;
    emailUsers = [[NSMutableArray alloc] init];
    
    NSString *textString = text;
    for (int i = 0; i < [allUsers count]; i++) {
        UserModel *testUser = [allUsers objectAtIndex:i];
        NSString *testEmail = testUser.email;
        if ([testEmail isEqualToString:textString]) {
            [emailUsers addObject:testUser];
        }
    }
    
    NSArray *subviews = emailScroll.subviews;
    for (int i = 0; i < [subviews count]; i++) {
        UIView *view = [subviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [emailUsers count]; i++) {
        UserModel *tempUser = [emailUsers objectAtIndex:i];
        ProfilePanelView *profilePanel = [[ProfilePanelView alloc] initWithUser:tempUser];
        profilePanel.frame = CGRectMake(i * (scrollHeight + scrollSpacing), 0, scrollHeight, scrollHeight);
        [emailScroll addSubview:profilePanel];
        emailScroll.contentSize = CGSizeMake((i + 1) * (scrollHeight + scrollSpacing), scrollHeight);
    }
}

-(void) userSwiped:(UIGestureRecognizer *)recog {
    if (recog.state == UIGestureRecognizerStateEnded) {
        [self endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
