//
//  ImagePostModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "ImagePostModel.h"
#import "TagModel.h"
#import "TagIconView.h"
#import "DBManager.h"
#import "ImagePostView.h"

@implementation ImagePostModel {
    DBManager *manager;
}

@synthesize ID;
@synthesize intType;
@synthesize type;
@synthesize images;
@synthesize imageSources;
@synthesize postID;
@synthesize post;
@synthesize view;

-(id) initWithID:(NSInteger)_ID {
    self = [super init];
    ID = _ID;
    
    return self;
}

-(id) initWithDBArray:(NSArray *)array {
    self = [super init];
    
    if ([array count] == 1) {
        array = [array objectAtIndex:0];
    }
    
    ID = [[array objectAtIndex:0] integerValue];
    intType = [[array objectAtIndex:1] integerValue];
    switch (intType) {
        case 1:
            type = onePic;
            break;
            
        case 2:
            type = twoPic;
            break;
            
        case 3:
            type = threePic;
            break;
            
        default:
            break;
    }
    
    if (imageSources == nil) {
        imageSources = [[NSMutableArray alloc] init];
    }
    [imageSources addObject:[array objectAtIndex:2]];
    
    postID = [[array objectAtIndex:3] integerValue];
    
    [self loadComponents];
    
    return self;
}

-(void) loadComponents {
    if (images == nil) {
        images = [[NSMutableArray alloc] init];
    }
    
    //[images addObject:[UIImage imageNamed:@"default.png"]];
    
    for (int i = 0; i < [imageSources count]; i++) {
        NSString *string = [imageSources objectAtIndex:i];
        NSArray *subStrings = [string componentsSeparatedByString:@"/"];
        NSString *fileName = [subStrings lastObject];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths objectAtIndex:0];
        docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
        
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSString *dataPath = [docPath stringByAppendingPathComponent:fileName];
        
        UIImage *image = [UIImage imageWithContentsOfFile:dataPath];
        if (image == nil) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageSources objectAtIndex:0]]]];
        }
        [images addObject:image];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageReady:)
                                                     name:dataPath
                                                   object:nil];
    }
}

-(void) imageReady:(NSNotification *)notif {
    NSString *source = notif.name;
    [images addObject:[UIImage imageWithContentsOfFile:source]];
}

-(void) addImagePost:(ImagePostModel *)model {
    NSMutableArray *newImageSrcs = model.imageSources;
    
    for (int i = 0; i < [newImageSrcs count]; i++) {
        [imageSources addObject:[newImageSrcs objectAtIndex:i]];
        
        NSString *string = [newImageSrcs objectAtIndex:i];
        NSArray *subStrings = [string componentsSeparatedByString:@"/"];
        NSString *fileName = [subStrings lastObject];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths objectAtIndex:0];
        docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
        
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSString *dataPath = [docPath stringByAppendingPathComponent:fileName];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageReady:)
                                                     name:dataPath
                                                   object:nil];
    }
    
    NSMutableArray *newImages = model.images;
    for (int i = 0; i < [newImages count]; i++) {
        [images addObject:[newImages objectAtIndex:i]];
    }
    
    ID = -2;
    
}

@end
