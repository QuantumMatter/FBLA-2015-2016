//
//  RatingModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "RatingModel.h"

@implementation RatingModel

@synthesize ID;
@synthesize postID;
@synthesize post;

@synthesize overallRating;
@synthesize proRating;
@synthesize styleRating;
@synthesize appRating;

-(void) pushToServer {
    NSString *stringURL = @"http://24.8.58.134/FocalPoint/API/RatingsAPI/";
    NSMutableURLRequest *request;
    NSString *dataString = [NSString stringWithFormat:@"PostID=%ld&Appropriate=%ld&Overall=%ld&Professional=%ld&Style=%ld", postID, appRating, overallRating, proRating, styleRating];
    if (ID < 0) {
        request = [self postRequestFor:[NSURL URLWithString:stringURL] withDataString:dataString];
    } else {
        stringURL = [NSString stringWithFormat:@"%@%ld", stringURL, (long)ID];
        dataString = [NSString stringWithFormat:@"%@&ID=%ld", dataString, (long)ID];
        request = [self putRequestWithURL:[NSURL URLWithString:stringURL] andDataString:dataString];
    }
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(id) initWithDBArray:(NSArray *)array {
    self = [super init];
    
    if ([array count] == 1) {
        array = [array objectAtIndex:0];
    }
    
    if ([array count] == 0) {
        ID = -3;
        postID = -3;
        
        overallRating = 5;
        proRating = 5;
        styleRating = 5;
        appRating = 5;
        return self;
    }
    
    ID = [[array objectAtIndex:0] integerValue];
    postID = [[array objectAtIndex:1] integerValue];
    
    overallRating = [[array objectAtIndex:2] integerValue];
    proRating = [[array objectAtIndex:3] integerValue];
    styleRating = [[array objectAtIndex:4] integerValue];
    appRating = [[array objectAtIndex:5] integerValue];
    
    return self;
}

-(NSMutableURLRequest *) putRequestWithURL:(NSURL *)URL andDataString:(NSString *)dataString {
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dataLength = [NSString stringWithFormat:@"%lu", (unsigned long) [data length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"PUT"];
    [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    return request;
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

@end
