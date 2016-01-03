//
//  DBDump.m
//  FBLA-2016
//
//  Created by David Kopala on 1/2/16.
//  Copyright © 2016 David Kopala. All rights reserved.
//

#import "DBDump.h"
#import "DBManager.h"

@implementation DBDump {
    NSTimer *timer;
    
    NSMutableURLRequest *commentsRequest;
    NSMutableURLRequest *friendsRequest;
    NSMutableURLRequest *imagePostsRequest;
    NSMutableURLRequest *postsRequest;
    NSMutableURLRequest *ratingsRequest;
    NSMutableURLRequest *tagsRequest;
    NSMutableURLRequest *usersRequest;
    
    NSURLConnection *commentsConn;
    NSURLConnection *friendsConn;
    NSURLConnection *imagePostsConn;
    NSURLConnection *postsConn;
    NSURLConnection *ratingsConn;
    NSURLConnection *tagsConn;
    NSURLConnection *usersConn;
    
    DBManager *manager;
}

#define rootURL     @"http://focal.azurewebsites.net/API/"

-(id) initWithInterval:(NSInteger)time {
    self = [super init];
    
    manager = [[DBManager alloc] init];
    
    NSMutableURLRequest *baseRequest = [[NSMutableURLRequest alloc] init];
    
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@CommentsAPI", rootURL]];
    NSURL *friendsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@FriendsAPI", rootURL]];
    NSURL *imagePostsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@ImagePostsAPI", rootURL]];
    NSURL *postsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@PostsAPI", rootURL]];
    NSURL *ratingsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@RatingsAPI", rootURL]];
    NSURL *tagsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@TagsAPI", rootURL]];
    NSURL *usersURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@UsersAPI", rootURL]];
    
    commentsRequest = baseRequest;
    friendsRequest = baseRequest;
    imagePostsRequest = baseRequest;
    postsRequest = baseRequest;
    ratingsRequest = baseRequest;
    tagsRequest = baseRequest;
    usersRequest = baseRequest;
    
    commentsRequest.URL = commentsURL;
    friendsRequest.URL = friendsURL;
    imagePostsRequest.URL = imagePostsURL;
    postsRequest.URL = postsURL;
    ratingsRequest.URL = ratingsURL;
    tagsRequest.URL = tagsURL;
    usersRequest.URL = usersURL;
    
    timer = [NSTimer timerWithTimeInterval:time
                                    target:self
                                  selector:@selector(copyOnlineDB)
                                  userInfo:nil
                                   repeats:YES];
    
    return self;
}

-(void) copyOnlineDB {
    NSLog(@"Copying DB");
    
    commentsConn = [[NSURLConnection alloc] initWithRequest:commentsRequest
                                                   delegate:self
                                           startImmediately:YES];
    friendsConn = [[NSURLConnection alloc] initWithRequest:friendsRequest
                                                   delegate:self
                                           startImmediately:YES];
    imagePostsConn = [[NSURLConnection alloc] initWithRequest:imagePostsRequest
                                                   delegate:self
                                           startImmediately:YES];
    postsConn = [[NSURLConnection alloc] initWithRequest:postsRequest
                                                   delegate:self
                                           startImmediately:YES];
    ratingsConn = [[NSURLConnection alloc] initWithRequest:ratingsRequest
                                                   delegate:self
                                           startImmediately:YES];
    tagsConn = [[NSURLConnection alloc] initWithRequest:tagsRequest
                                                   delegate:self
                                           startImmediately:YES];
    usersConn = [[NSURLConnection alloc] initWithRequest:usersRequest
                                                   delegate:self
                                           startImmediately:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == commentsConn) {
        [self parseComments:data];
    }
    if (connection == friendsConn) {
        [self parseFriends:data];
    }
    if (connection == imagePostsConn) {
        [self parseImagePosts:data];
    }
    if (connection == postsConn) {
        [self parsePosts:data];
    }
    if (connection == ratingsConn) {
        [self parseRatings:data];
    }
    if (connection == tagsConn) {
        [self parseTags:data];
    }
    if (connection == usersConn) {
        [self parseUsers:data];
    }
    
}

-(void) parseComments:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
        NSArray *keys = [dict allKeys];
        NSArray *values = [dict allValues];
        
        NSString *keyString = @"";
        NSString *valueString = @"";
        
        for (int a = 0; i < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"code"] class]];
            NSLog(class);
            
            if ([class isEqualToString:@"NSString"]) {
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            
            if (a == (dict.count - 1)) {
                keyString = [NSString stringWithFormat:@"%@%@", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@", valueString, value];
            } else {
                keyString = [NSString stringWithFormat:@"%@%@,", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@,", valueString, value];
            }
        }
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO comments (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(void) parseFriends:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}

-(void) parseImagePosts:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}

-(void) parsePosts:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}

-(void) parseRatings:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}

-(void) parseTags:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}

-(void) parseUsers:(NSData *)data {
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dict = [jsonArray objectAtIndex:i];
    }
}


@end
