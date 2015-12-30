//
//  FindFriendsView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserModel.h"
#import "ProfilePanelView.h"

@interface FindFriendsView : UIView <CLLocationManagerDelegate, UserModelDelegate, UITextFieldDelegate, ProfilePanelDelegate>

@property UIScrollView *scrollView;

@property UILabel *nearbyTitle;
@property UILabel *byLocationTitle;
@property UIScrollView *nearbyScroll;

@property UILabel *bluetoothTitle;
@property UIScrollView *bluetoothScroll;

@property UILabel *emailTitle;
@property UITextField *emailField;
@property UIScrollView *emailScroll;

@property NSMutableArray *nFriends;

@property CLLocation *location;

-(id) initWithFrame:(CGRect)frame;

-(void) userSwiped:(UIPanGestureRecognizer *)recog;

-(void) activateView;

@end
