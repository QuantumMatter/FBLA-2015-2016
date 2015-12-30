//
//  UserModel.h
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol UserModelDelegate <NSObject>

-(void) zipFound:(id)sender;

@end

@interface UserModel : NSObject 

@property NSInteger ID;

@property UIImage *profilePic;
@property NSString *profilePicSrc;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *email;

@property NSInteger zipCode;
@property float latitude;
@property float longitude;
@property CLLocation *location;

@property NSInteger followers;
@property NSInteger following;

@property id<UserModelDelegate> delegate;

-(id) initWithProfileSrc:(NSString *)profileSrc andFirstName:(NSString *)fName andLastName:(NSString *)lName;

-(void) test1;
-(void) test2;
-(void) test3;
-(void) test4;

@end
