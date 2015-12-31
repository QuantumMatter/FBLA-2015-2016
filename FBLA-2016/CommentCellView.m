//
//  CommentCellView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "CommentCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommentCellView {
    CommentModel *comment;
    
    UITextField *newComment;
}

-(id) initWithFrame:(CGRect)frame andComment:(CommentModel *)comm {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    comment = comm;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    float midY = self.frame.size.height / 2;
    float xSpace = 0.15 * self.frame.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * self.frame.size.height, 0.8 * self.frame.size.height)];
    imageView.image = comment.user.profilePic;
    imageView.center = CGPointMake(midY, midY);
    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * xSpace, 0.1 * self.frame.size.height, 0.65 * self.frame.size.width, 0.8 * self.frame.size.height)];
    label.text = comment.comment;
    [self addSubview:label];
}

-(id) initForNewCommentWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    float midY = self.frame.size.height / 2;
    float xSpace = 0.15 * self.frame.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * self.frame.size.height, 0.8 * self.frame.size.height)];
    imageView.image = comment.user.profilePic;
    imageView.center = CGPointMake(midY, midY);
    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
    [self addSubview:imageView];
    
    newComment = [[UITextField alloc] initWithFrame:CGRectMake(2 * xSpace, 0.1 * self.frame.size.height, 0.5 * self.frame.size.width, 0.8 * self.frame.size.height)];
    newComment.placeholder = @"Comment";
    [self addSubview:newComment];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    float xOrigin = newComment.frame.origin.x + newComment.frame.size.width;
    button.frame = CGRectMake(xOrigin, 0, self.frame.size.width - xOrigin, self.frame.size.height);
    [button setTitle:@"GO" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendNewComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return self;
}

-(void) sendNewComment {
    
}

@end
