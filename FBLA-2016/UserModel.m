//
//  UserModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel {
    NSURLConnection *imageConn;
    NSURLConnection *modelConn;
}

@synthesize delegate;

@synthesize ID;

@synthesize profilePic;
@synthesize profilePicSrc;
@synthesize profilePicSrcLocal;

@synthesize firstName;
@synthesize lastName;
@synthesize email;

@synthesize latitude;
@synthesize longitude;
@synthesize location;

@synthesize zipCode;

@synthesize followers;
@synthesize following;

@synthesize gender;

#define kIDKey              @"ID"

#define kProfilePicSrcKey   @"ProfilePicture"

#define kFirstNameKey       @"FirstName"
#define kLastNameKey        @"LastName"
#define kEmailKey           @"Email"

#define kLongitudeKey       @"Longitude"
#define kLatitudeKey        @"Latitude"

#define kZipCodeKey         @"ZipCode"

#define kFollowersKey       @"Followers"
#define kFollowingKey       @"Following"

#define kGenderKey          @"Gender"

-(id) initWithCoder:(NSCoder *)decoder {
    ID = [decoder decodeIntegerForKey:kIDKey];
    self = [self initWithID:ID];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:ID forKey:kIDKey];
}

-(id) initWithID:(NSInteger)_ID {
    self = [super init];
    ID = _ID;
    [self loadCounterparts];
    
    [self loadComponents];
    
    /*profilePicSrc = profileSrc;
    firstName = fName;
    lastName = lName;
    profilePic = [UIImage imageNamed:@"default.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Run BG Task Here
        profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicSrc]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //Return to main thread to update UI
        });
    });*/
    return self;
}

-(void) loadCounterparts {
    
}

-(void) loadComponents {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profilePicReady)
                                                 name:profilePicSrcLocal
                                               object:nil];
}

-(void) profilePicReady {
    profilePic = [UIImage imageWithContentsOfFile:profilePicSrcLocal];
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

-(void) pushToServer {
    [self pushImage];
}

-(void) pushImage {
    
}

-(void) pushModel {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://24.8.58.134/FBLA2016/API/UsersAPI"]];
    if (ID == -1) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"PUT"];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == imageConn) {
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        profilePicSrc = response;
        NSLog(response);
        [self pushModel];
    } else if (connection == modelConn) {
        NSLog(@"Connection Complete");
        NSString *resposne = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(resposne);
        UserModel *newUser = [[UserModel alloc] initWithJSONString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        if (newUser.ID != ID) {
            [self copyFromUser:newUser];
            [delegate user:self receivedNewID:newUser.ID];
        }
    }
}

-(void) copyFromUser:(UserModel *)newUser {
    ID = newUser.ID;
    
    profilePicSrc = newUser.profilePicSrc;
    
}

-(id) initWithJSONString:(NSString *)jString {
    self = [super init];
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[jString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions
                                                           error:&error];
    NSDictionary *dict = [jsonArray objectAtIndex:0];
    ID = [[dict objectForKey:kIDKey] integerValue];
    
    profilePicSrc = [dict objectForKey:kProfilePicSrcKey];
    
    firstName = [dict objectForKey:kFirstNameKey];
    lastName = [dict objectForKey:kLastNameKey];
    email = [dict objectForKey:kEmailKey];
    
    latitude = [[dict objectForKey:kLatitudeKey] floatValue];
    longitude = [[dict objectForKey:kLongitudeKey] floatValue];
    
    followers = [[dict objectForKey:kFollowersKey] integerValue];
    following = [[dict objectForKey:kFollowingKey] integerValue];
    
    zipCode = [[dict objectForKey:kZipCodeKey] integerValue];
    
    gender = [dict objectForKey:kGenderKey];
    
    [self loadComponents];
    
    return self;
}

@end
