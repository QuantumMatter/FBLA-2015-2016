//
//  PersonalInfoView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property UIScrollView *scrollView;

@property UIImageView *profilePic;
@property UITextField *firstName;
@property UITextField *lastName;

@property UISegmentedControl *genderControl;

@property UILabel *birthMonth;
@property UILabel *birthDay;
@property UILabel *birthYear;

@property UIDatePicker *pickerView;

@property UITextField *emailAddress;

@property UITextField *password;
@property UITextField *confirmPassword;

@property UIViewController *parentController;

-(id) initWithViewAndFrame:(CGRect)frame;
-(void) userSwiped:(UIPanGestureRecognizer *)recog;

-(void) activateView;

@end
