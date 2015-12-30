//
//  UserModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize delegate;

@synthesize ID;

@synthesize profilePic;
@synthesize profilePicSrc;

@synthesize firstName;
@synthesize lastName;
@synthesize email;

@synthesize latitude;
@synthesize longitude;
@synthesize location;

@synthesize zipCode;

@synthesize followers;
@synthesize following;

-(id) initWithProfileSrc:(NSString *)profileSrc andFirstName:(NSString *)fName andLastName:(NSString *)lName {
    self = [super init];
    
    profilePicSrc = profileSrc;
    firstName = fName;
    lastName = lName;
    profilePic = [UIImage imageNamed:@"default.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Run BG Task Here
        profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicSrc]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //Return to main thread to update UI
        });
    });
    return self;
}

-(void) test1 {
    firstName = @"David";
    lastName = @"Kopala";
    profilePic = [UIImage imageNamed:@"default.png"];
    latitude = 39.887017;
    longitude = -105.012729;
    email = @"davidk@ihcconline.com";
    
    [self doBGOps];
}

-(void) test2 {
    firstName = @"Test";
    lastName = @"02";
    profilePic = [UIImage imageNamed:@"default.png"];
    latitude = 39;
    longitude = -105;
    email = @"test2@test.com";
    
    [self doBGOps];
}

-(void) test3 {
    firstName = @"Test";
    lastName = @"03";
    profilePic = [UIImage imageNamed:@"default.png"];
    latitude = 40;
    longitude = -106;
    email = @"test3@test.com";
    
    [self doBGOps];
}

-(void) test4 {
    firstName = @"Test";
    lastName = @"04";
    profilePic = [UIImage imageNamed:@"default.png"];
    latitude = 40;
    longitude = -105;
    email = @"test4@test.com";
    
    [self doBGOps];
}

-(void) doBGOps {
    location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                       CLPlacemark *placemark = [placemarks lastObject];
                       zipCode = [placemark.postalCode integerValue];
                       NSLog(placemark.postalCode);
                       [delegate zipFound:self];
                       
                   }];
}

@end
