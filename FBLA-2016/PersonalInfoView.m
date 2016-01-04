//
//  PersonalInfoView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PersonalInfoView.h"

@implementation PersonalInfoView {
    UIPanGestureRecognizer *pan;
    CGPoint firstPoint;
    
    NSMutableArray *months;
}

@synthesize scrollView;

@synthesize profilePic;

@synthesize firstName;
@synthesize lastName;

@synthesize emailAddress;

@synthesize birthMonth;
@synthesize birthDay;
@synthesize birthYear;

@synthesize pickerView;

@synthesize password;
@synthesize confirmPassword;

@synthesize genderControl;

@synthesize parentController;

-(id) init {
    self = [super init];
    [self loadViews];
    return self;
}

-(id) initWithViewAndFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"RegisterViews" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    [self loadViews];
    return self;
}

-(void) loadViews {
    months = [[NSMutableArray alloc] init];
    [months addObject:@"January"];
    [months addObject:@"February"];
    [months addObject:@"March"];
    [months addObject:@"April"];
    [months addObject:@"May"];
    [months addObject:@"June"];
    [months addObject:@"July"];
    [months addObject:@"August"];
    [months addObject:@"September"];
    [months addObject:@"October"];
    [months addObject:@"November"];
    [months addObject:@"December"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month = [components month];
    birthMonth.text = [months objectAtIndex:month - 1];
    
    NSInteger day = [components day];
    birthDay.text = [NSString stringWithFormat:@"%ld", (long)day];
    
    NSInteger year = [components year];
    birthYear.text = [NSString stringWithFormat:@"%ld", (long)year];
    //[self addGestureRecognizer:pan];
    
    NSInteger yPos = 65;
    NSInteger spacing = 25;
    
    yPos += spacing;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    [self addSubview:scrollView];
    
    NSInteger profileSize = 0.2 * self.frame.size.height;
    profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos, profileSize, profileSize)];
    profilePic.image = [UIImage imageNamed:@"profile-pic.jpg"];
    [scrollView addSubview:profilePic];
    //yPos += profilePic.frame.size.height + spacing;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    NSInteger labelHeight = 0.1 * self.frame.size.height;
    
    firstName = [[UITextField alloc] initWithFrame:CGRectMake(profilePic.frame.size.width, yPos, self.frame.size.width - profilePic.frame.size.height, labelHeight)];
    [firstName setBackgroundColor:[UIColor whiteColor]];
    [firstName setFont:[firstName.font fontWithSize:31]];
    [firstName setPlaceholder:@"First Name"];
    [scrollView addSubview:firstName];
    yPos += firstName.frame.size.height;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    lastName = [[UITextField alloc] initWithFrame:CGRectMake(profilePic.frame.size.width, yPos, self.frame.size.width - profilePic.frame.size.height, labelHeight)];
    [lastName setBackgroundColor:firstName.backgroundColor];
    [lastName setFont:[firstName.font fontWithSize:31]];
    [lastName setPlaceholder:@"Last Name"];
    [scrollView addSubview:lastName];
    yPos += lastName.frame.size.height + spacing;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, labelHeight)];
    [emailAddress setBackgroundColor:firstName.backgroundColor];
    [emailAddress setFont:[firstName.font fontWithSize:31]];
    [emailAddress setPlaceholder:@"Email Address"];
    [scrollView addSubview:emailAddress];
    yPos += emailAddress.frame.size.height + spacing;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    UIView *dateContainer = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, labelHeight)];
    [dateContainer setBackgroundColor:firstName.backgroundColor];
    [dateContainer addGestureRecognizer:tap];
    [scrollView addSubview:dateContainer];
    
    NSInteger third = self.frame.size.width / 3;
    birthMonth = [[UILabel alloc] initWithFrame:CGRectMake(0 * third, 0, third, labelHeight)];
    [birthMonth setBackgroundColor:[UIColor lightTextColor]];
    birthMonth.text = @"December";
    [dateContainer addSubview:birthMonth];
    
    birthDay = [[UILabel alloc] initWithFrame:CGRectMake(1 * third, 0, third, labelHeight)];
    [birthDay setBackgroundColor:birthMonth.backgroundColor];
    birthDay.text = @"28";
    [dateContainer addSubview:birthDay];
    
    birthYear = [[UILabel alloc] initWithFrame:CGRectMake(2 * third, 0, third, labelHeight)];
    [birthYear setBackgroundColor:birthMonth.backgroundColor];
    birthYear.text = @"2015";
    [dateContainer addSubview:birthYear];
    yPos += dateContainer.frame.size.height + spacing;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, labelHeight)];
    [password setBackgroundColor:firstName.backgroundColor];
    [password setFont:[firstName.font fontWithSize:31]];
    [password setPlaceholder:@"Password"];
    [scrollView addSubview:password];
    yPos += password.frame.size.height;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, labelHeight)];
    [confirmPassword setBackgroundColor:firstName.backgroundColor];
    [confirmPassword setFont:[firstName.font fontWithSize:31]];
    [confirmPassword setPlaceholder:@"Confirm Password"];
    [scrollView addSubview:confirmPassword];
    yPos += confirmPassword.frame.size.height + spacing;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    genderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Male", @"Female", nil]];
    genderControl.frame = CGRectMake(0, yPos, self.frame.size.width, labelHeight);
    [scrollView addSubview:genderControl];
    yPos += genderControl.frame.size.height + spacing;
    yPos += 150;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapped)];
    [profilePic addGestureRecognizer:picTap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = profilePic.frame;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(profilePicTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void) showDatePicker:(UITapGestureRecognizer *)recog {
    NSLog(@"User Tapped");
    if (pickerView == nil) {
        pickerView = [[UIDatePicker alloc] init];
        CGRect frameA = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5 * self.frame.size.height);
        pickerView.frame = frameA;
        [self addSubview:pickerView];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [pickerView  addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        pickerView.alpha = 0.0;
        pickerView.backgroundColor = [UIColor lightTextColor];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frameB = CGRectMake(0, 0.5 * self.frame.size.height, self.frame.size.width, 0.5 * self.frame.size.height);
            pickerView.frame = frameB;
            pickerView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frameC = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5 * self.frame.size.height);
            pickerView.frame = frameC;
            pickerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [pickerView removeFromSuperview];
            pickerView = nil;
        }];
    }
}

-(void) datePickerChanged:(UIDatePicker *)picker {
    NSLog(@"Date Picker Value Changed");
    NSDate *date = picker.date;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger month = [components month];
    birthMonth.text = [months objectAtIndex:month - 1];
    
    NSInteger day = [components day];
    birthDay.text = [NSString stringWithFormat:@"%ld", (long)day];
    
    NSInteger year = [components year];
    birthYear.text = [NSString stringWithFormat:@"%ld", (long)year];
}

-(void) userSwiped:(UIPanGestureRecognizer *)recog {
    if (recog.state == UIGestureRecognizerStateBegan) {
        firstPoint = [recog locationInView:self];
    }
    
    if (recog.state == UIGestureRecognizerStateEnded) {
        CGPoint lastPoint;
        lastPoint = [recog locationInView:self];
        
        float yDelta = firstPoint.y - lastPoint.y;
        if (yDelta < -50) {
            [self endEditing:YES];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frameC = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5 * self.frame.size.height);
                pickerView.frame = frameC;
                pickerView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [pickerView removeFromSuperview];
                pickerView = nil;
            }];
        }
    }
}

-(void) profilePicTapped {
    NSLog(@"Profile Pic Tapped");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Picture"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:self];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 1) {
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
    }
    NSString *string = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
    NSLog(string);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [parentController presentViewController:picker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    profilePic.image = image;
    
    [parentController dismissViewControllerAnimated:YES completion:nil];
}

@end
