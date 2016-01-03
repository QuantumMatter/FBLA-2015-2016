//
//  PostModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PostModel.h"
#import "DBManager.h"
#import "ImagePostModel.h"
#import "ImagePostView.h"

@implementation PostModel {
    DBManager *manager;
}

@synthesize ID;
@synthesize userID;
@synthesize user;
@synthesize imageViews;
@synthesize images;
@synthesize frameForViews;
@synthesize datePosted;

-(id) initWithID:(NSInteger)_ID {
    self = [super init];
    ID = _ID;
    
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM Posts WHERE ID LIKE %ld", ID]];
    self = [self initWithPostArray:array];
    
    return self;
}

-(id) initWithPostArray:(NSArray *)array {
    self = [super init];
    
    if ([array count] == 1) {
        array = [array objectAtIndex:0];
    }
    
    ID = [[array objectAtIndex:0] integerValue];
    userID = [[array objectAtIndex:1] integerValue];
    datePosted = [array objectAtIndex:2];
    
    [self loadComponents];
    
    return self;
}

-(void) loadComponents {
    user = [[UserModel alloc] initWithID:userID];
    [self loadMyImages];
}

-(void) loadMyImages {
    NSMutableArray *imageModels = [self getMyImagesModel];
    if (imageViews == nil) {
        imageViews = [[NSMutableArray alloc] init];
    }
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, screen.size.width, screen.size.width);
    
    for (int i = 0; i < [imageModels count]; i++) {
        ImagePostModel *imagePost = [imageModels objectAtIndex:i];
        ImagePostView *imageView = [[ImagePostView alloc] initWithFrame:frame andModel:imagePost];
        [imageViews addObject:imageView];
        for (int b = 0; b < [imagePost.images count]; b++) {
            if (images == nil) {
                images = [[NSMutableArray alloc] init];
            }
            [images addObject:[imagePost.images objectAtIndex:b]];
        }
    }
}

-(NSMutableArray *) getMyImagesModel {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM ImagePosts WHERE PostID LIKE %ld", ID]];
    
    NSMutableArray *imagePosts = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++) {
        NSArray *imagePostArray = [array objectAtIndex:i];
        ImagePostModel *imagePost = [[ImagePostModel alloc] initWithDBArray:imagePostArray];
        [imagePosts addObject:imagePost];
    }
    
    return imagePosts;
}

@end
