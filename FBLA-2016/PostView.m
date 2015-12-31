//
//  PostView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PostView.h"
#import "UserModel.h"
#import "SlidingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RatingView.h"
#import "CommentModel.h"
#import "CommentCellView.h"
#import "TagView.h"

@implementation PostView {
    PostModel *post;
    
    UserModel *postUser;
    
    SlidingViewController *imagesContainer;
}

-(id) initWithFrame:(CGRect)frame andPost:(PostModel *)postModel {
    self = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    post = postModel;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    postUser = post.user;
    
    NSInteger yPos = 0;
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 50)];
    topBar.backgroundColor = [UIColor redColor];
    
    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * topBar.frame.size.height, 0.8 * topBar.frame.size.height)];
    profilePic.image = postUser.profilePic;
    profilePic.layer.cornerRadius = profilePic.frame.size.height / 2;
    profilePic.center = CGPointMake(topBar.frame.size.height / 2, topBar.frame.size.height / 2);
    [topBar addSubview:profilePic];
    
    float labelX = profilePic.frame.origin.x + profilePic.frame.size.height + 8;
    float labelWidth = self.frame.size.width - labelX - 50;
    CGRect labelFrame = CGRectMake(labelX, 0, labelWidth, topBar.frame.size.height);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
    NSString *name = [NSString stringWithFormat:@"%@ %@", postUser.firstName, postUser.lastName];
    nameLabel.text = name;
    [topBar addSubview:nameLabel];
    
    [self addSubview:topBar];
    yPos += topBar.frame.size.height;
    
    imagesContainer = [[SlidingViewController alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, self.frame.size.width) andDelegate:self];
    [self addSubview:imagesContainer];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:imagesContainer action:@selector(swiped:)];
    [imagesContainer addGestureRecognizer:pan];
    
    yPos += imagesContainer.frame.size.height;
    
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 150) andPostID:post.ID];
    [self addSubview:tagView];
    
    yPos += tagView.frame.size.height;
    
    RatingView *ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 0.15 * self.frame.size.width)];
    [self addSubview:ratingView];
    
    yPos += ratingView.frame.size.height;
    
    UIView *commentsView = [self commentsViewWithLength:(self.frame.size.height - yPos)];
    [self addSubview:commentsView];
    
    yPos += commentsView.frame.size.height;
}

-(UIView *) commentsViewWithLength:(float)length {
    NSMutableArray *comments = [self getMyComments];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, length)];
    
    float yPos = 8;
    
    for (int i = 0; i < [comments count]; i++) {
        CommentModel *comment = [comments objectAtIndex:i];
        CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 150);
        CommentCellView *commentCell = [[CommentCellView alloc] initWithFrame:frame andComment:comment];
        commentCell.frame = frame;
        [scrollView addSubview:commentCell];
        yPos += 8 + commentCell.frame.size.height;
    }
    
    CommentCellView *newComment = [[CommentCellView alloc] initForNewCommentWithFrame:CGRectMake(0, yPos, self.frame.size.width, 150)];
    yPos += 8 + newComment.frame.size.height;
    
    [scrollView addSubview:newComment];
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    return scrollView;
}

-(NSMutableArray *) getMyComments {
    return nil;
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [post.imageViews objectAtIndex:index];
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return [post.imageViews count];
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [NSString stringWithFormat:@"%ld", (long)index];
}

@end
