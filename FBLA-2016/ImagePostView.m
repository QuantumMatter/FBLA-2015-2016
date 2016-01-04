//
//  ImagePostView.m
//  FBLA-2016
//
//  Created by David Kopala on 1/1/16.
//  Copyright © 2016 David Kopala. All rights reserved.
//

#import "ImagePostView.h"
#import "TagModel.h"
#import "TagIconView.h"

@implementation ImagePostView {
    ImagePostModel *post;
}

@synthesize delegate;
@synthesize imageViews;

-(id) initWithFrame:(CGRect)frame andModel:(ImagePostModel *)model {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ImagePostView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    post = model;
    [self loadComponents];
    return self;
}

-(id) initWithFrame:(CGRect)frame forNewPost:(NSInteger)count {
    ImagePostModel *postModel = [[ImagePostModel alloc] init];
    postModel.images = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        UIImage *image = [UIImage imageNamed:@"camera.png"];
        [postModel.images addObject:image];
    }
    postModel.ID = -2;
    self = [self initWithFrame:frame andModel:postModel];
    return self;
}

-(void) loadComponents {
    imageViews = [[NSMutableArray alloc] init];
    
    switch (post.type) {
        case onePic:
            [self loadOnePic];
            break;
            
        case twoPic:
            [self loadTwoPic];
            break;
            
        case threePic:
            [self loadThreePic];
            break;
            
        default:
            break;
    }
    [self loadTags];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
    //[self addGestureRecognizer:tap];
}

-(void) userTapped:(UITapGestureRecognizer *)tap {
    for (int i = 0; i < [imageViews count]; i++) {
        UIImageView *imageView = [imageViews objectAtIndex:i];
        CGPoint loc = [tap locationInView:imageView];
        BOOL OK = CGRectContainsPoint(imageView.frame, loc);
        if (OK) {
            [delegate userSelectedImage:imageView];
        }
    }
}

-(void) loadOnePic {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = [post.images objectAtIndex:0];
    [self addSubview:imageView];
    [imageViews addObject:imageView];
}

-(void) loadTwoPic {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float halfWidth = width / 2;
    float halfHeight = height / 2;
    
    UIImageView *first = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, halfWidth, height)];
    first.image = [post.images objectAtIndex:0];
    [self addSubview:first];
    [imageViews addObject:first];
    
    UIImageView *second = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, 0, halfWidth, height)];
    second.image = [post.images objectAtIndex:1];
    [self addSubview:second];
    [imageViews addObject:second];
}

-(void) loadThreePic {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float halfWidth = width / 2;
    float halfHeight = height / 2;
    
    UIImageView *first = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, halfWidth, height)];
    first.image = [post.images objectAtIndex:0];
    [self addSubview:first];
    [imageViews addObject:first];
    
    UIImageView *second = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, 0, halfWidth, halfHeight)];
    second.image = [post.images objectAtIndex:1];
    [self addSubview:second];
    [imageViews addObject:second];
    
    UIImageView *third = [[UIImageView alloc] initWithFrame:CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight)];
    third.image = [post.images objectAtIndex:2];
    [self addSubview:third];
    [imageViews addObject:third];
}

-(void) loadTags {
    NSMutableArray *tags = [self getMyTags];
    for (int i = 0; i < [tags count]; i++) {
        TagModel *tag = [tags objectAtIndex:i];
        TagIconView *tagIcon = [[TagIconView alloc] initWIthNumber:tag.number];
        tagIcon.center = CGPointMake(self.frame.size.width * tag.xPos, self.frame.size.height * tag.yPos);
        [self addSubview:tagIcon];
    }
}

-(NSMutableArray *) getMyTags {
    return [[NSMutableArray alloc] init];
}

-(UIImageView *)imageForTap:(UITapGestureRecognizer *)tap {
    for (int i = 0; i < [imageViews count]; i++) {
        UIImageView *imageView = [imageViews objectAtIndex:i];
        CGPoint loc = [tap locationInView:imageView];
        BOOL OK = CGRectContainsPoint(imageView.frame, loc);
        if (OK) {
            return imageView;
        }
    }
    return nil;
}

@end
