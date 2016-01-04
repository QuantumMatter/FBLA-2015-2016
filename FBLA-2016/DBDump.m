//
//  DBDump.m
//  FBLA-2016
//
//  Created by David Kopala on 1/2/16.
//  Copyright © 2016 David Kopala. All rights reserved.
//

#import "DBDump.h"
#import "DBManager.h"
#import <UIKit/UIKit.h>

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
    
    NSString *docPath;
}

#define rootURL     @"http://24.8.58.134/FocalPoint/API/"

-(id) initWithInterval:(NSInteger)time {
    self = [super init];
    
    manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    [manager executeQuery:@"DELETE FROM comments"];
    [manager executeQuery:@"DELETE FROM friends"];
    [manager executeQuery:@"DELETE FROM imageposts"];
    [manager executeQuery:@"DELETE FROM posts"];
    [manager executeQuery:@"DELETE FROM comments"];
    [manager executeQuery:@"DELETE FROM tags"];
    [manager executeQuery:@"DELETE FROM users"];
    
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@CommentsAPI", rootURL]];
    NSURL *friendsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@FriendsAPI", rootURL]];
    NSURL *imagePostsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@ImagePostsAPI", rootURL]];
    NSURL *postsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@PostsAPI", rootURL]];
    NSURL *ratingsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@RatingsAPI", rootURL]];
    NSURL *tagsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@TagsAPI", rootURL]];
    NSURL *usersURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@UsersAPI", rootURL]];
    
    commentsRequest = [[NSMutableURLRequest alloc] init];
    friendsRequest = [[NSMutableURLRequest alloc] init];
    imagePostsRequest = [[NSMutableURLRequest alloc] init];
    postsRequest = [[NSMutableURLRequest alloc] init];
    ratingsRequest = [[NSMutableURLRequest alloc] init];
    tagsRequest = [[NSMutableURLRequest alloc] init];
    usersRequest = [[NSMutableURLRequest alloc] init];
    
    commentsRequest.URL = commentsURL;
    friendsRequest.URL = friendsURL;
    imagePostsRequest.URL = imagePostsURL;
    postsRequest.URL = postsURL;
    ratingsRequest.URL = ratingsURL;
    tagsRequest.URL = tagsURL;
    usersRequest.URL = usersURL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    [self copyOnlineDB];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:time
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
    [manager executeQuery:@"DELETE FROM comments"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
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
    [manager executeQuery:@"DELETE FROM friends"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
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
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO friends (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(void) parseImagePosts:(NSData *)data {
    [manager executeQuery:@"DELETE FROM imageposts"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            
            if ([key isEqualToString:@"Source"]) {
                key = @"LocalSource";
                NSString *fileName = [self getFileName:value];
                NSString *path = [docPath stringByAppendingPathComponent:fileName];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //Run BG Task Here
                    [self saveImage:path andSource:value];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSString *log = [NSString stringWithFormat:@"Saved Image At: %@", path];
                        NSLog(log);
                        [[NSNotificationCenter defaultCenter] postNotificationName:path
                                                                            object:nil];
                    });
                });
            }
            
            if (a == (dict.count - 1)) {
                keyString = [NSString stringWithFormat:@"%@%@", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@", valueString, value];
            } else {
                keyString = [NSString stringWithFormat:@"%@%@,", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@,", valueString, value];
            }
        }
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO imageposts (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(NSString *) getFileName:(NSString *)url {
    NSArray *components = [url componentsSeparatedByString:@"/"];
    NSString *fileName = [components lastObject];
    return fileName;
}

-(BOOL) saveImage:(NSString *)path andSource:(NSString *)source {
    UIImage *testImage = [UIImage imageWithContentsOfFile:source];
    if (testImage != nil) {
        return YES;
    }
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:source]];
    [imageData writeToFile:path atomically:YES];
    return YES;
}

-(void) parsePosts:(NSData *)data {
    [manager executeQuery:@"DELETE FROM posts"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
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
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO posts (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(void) parseRatings:(NSData *)data {
    [manager executeQuery:@"DELETE FROM ratings"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
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
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO ratings (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(void) parseTags:(NSData *)data {
    [manager executeQuery:@"DELETE FROM tags"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
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
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO tags (%@) VALUES (%@)", keyString, valueString]];
    }
}

-(void) parseUsers:(NSData *)data {
    [manager executeQuery:@"DELETE FROM users"];
    
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
        
        for (int a = 0; a < dict.count; a++) {
            NSString *key = [keys objectAtIndex:a];
            id value = [values objectAtIndex:a];
            
            NSString *class = [NSString stringWithFormat:@"%@", [[dict objectForKey:key] class]];
            
            if ([class isEqualToString:@"__NSCFString"] || [class isEqualToString:@"NSTaggedPointerString"]) {
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            
            if ([key isEqualToString:@"ProfilePic"]) {
                key = @"ProfilePicLocalSource";
                
                NSString *fileName = [self getFileName:value];
                NSString *path = [docPath stringByAppendingPathComponent:fileName];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //Run BG Task Here
                    BOOL success = [self saveImage:path andSource:value];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSString *log = [NSString stringWithFormat:@"Saved Profile Pic At: %@", path];
                        [[NSNotificationCenter defaultCenter] postNotificationName:path
                                                                            object:nil];
                    });
                });
            }
            
            if (a == (dict.count - 1)) {
                keyString = [NSString stringWithFormat:@"%@%@", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@", valueString, value];
            } else {
                keyString = [NSString stringWithFormat:@"%@%@,", keyString, key];
                valueString = [NSString stringWithFormat:@"%@%@,", valueString, value];
            }
        }
        [manager executeQuery:[NSString stringWithFormat:@"INSERT INTO users (%@) VALUES (%@)", keyString, valueString]];
    }
    NSArray *array = [manager loadDataFromDB:@"SELECT * FROM users"];
}


@end
