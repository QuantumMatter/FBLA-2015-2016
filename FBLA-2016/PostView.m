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
#import "DBManager.h"

@implementation PostView {
    PostModel *post;
    
    UserModel *postUser;
    
    SlidingViewController *imagesContainer;
    
    DBManager *manager;
    
    UIScrollView *scrollView;
}

-(id) initWithFrame:(CGRect)frame andPost:(PostModel *)postModel {
    self = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    post = postModel;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    float widthTest = self.frame.size.width;
    postUser = post.user;
    self.clipsToBounds = YES;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:scrollView];
    scrollView.clipsToBounds = YES;
    
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
    
    [scrollView addSubview:topBar];
    yPos += topBar.frame.size.height;
    
    
    imagesContainer = [[SlidingViewController alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, self.frame.size.width) andDelegate:self];
    [scrollView addSubview:imagesContainer];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:imagesContainer action:@selector(swiped:)];
    pan.cancelsTouchesInView = NO;
    [imagesContainer addGestureRecognizer:pan];
    
    yPos += imagesContainer.frame.size.height;
    
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 0.15 * self.frame.size.width) andPostID:post.ID];
    [scrollView addSubview:tagView];
    
    yPos += tagView.frame.size.height;
    
    RatingModel *rating = [self getRating];
    RatingView *ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, 0.15 * self.frame.size.width) andRating:rating];
    [scrollView addSubview:ratingView];
    
    yPos += ratingView.frame.size.height;
    
    UIView *commentsView = [self commentsViewWithLength:(self.frame.size.height - yPos)];
    commentsView.frame = CGRectMake(0, yPos, self.frame.size.width, 100);
    [scrollView addSubview:commentsView];
    [scrollView bringSubviewToFront:commentsView];
    
    yPos += commentsView.frame.size.height;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest:)];
    [imagesContainer addGestureRecognizer:tap];
    
    commentsView.userInteractionEnabled = YES;
    
    yPos = commentsView.frame.origin.y + commentsView.frame.size.height;
}

-(void) tapTest:(UITapGestureRecognizer *)tap {
    NSLog(@"Tap Test");
}

-(UIView *) commentsViewWithLength:(float)length {
    NSMutableArray *comments = [self getMyComments];
    
    float height = self.frame.size.height;
    float yPosA = height - length;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPosA, self.frame.size.width, length)];
    scrollView.clipsToBounds = NO;
    
    float yPos = 8;
    
    if (comments != nil) {
        for (int i = 0; i < [comments count]; i++) {
            CommentModel *comment = [comments objectAtIndex:i];
            CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 75);
            CommentCellView *commentCell = [[CommentCellView alloc] initWithFrame:frame andComment:comment];
            commentCell.frame = frame;
            [scrollView addSubview:commentCell];
            yPos += 8 + commentCell.frame.size.height;
        }
    }
    
    CommentCellView *newComment = [[CommentCellView alloc] initForNewCommentWithFrame:CGRectMake(0, yPos, self.frame.size.width, 100)];
    yPos += 8 + newComment.frame.size.height;
    
    [scrollView addSubview:newComment];
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    [scrollView bringSubviewToFront:newComment];
    
    return scrollView;
}

-(NSMutableArray *) getMyComments {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM Comments WHERE PostID LIKE %ld", post.ID]];
    
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    
    if ([array count] == 0) {
        return nil;
    }
    
    for (int i = 0; i < [array count]; i++) {
        NSArray *commentArray = [array objectAtIndex:i];
        CommentModel *comment = [[CommentModel alloc] initWithDBArray:commentArray];
        [comments addObject:comment];
    }
    
    return comments;
}

-(RatingModel *) getRating {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * from ratings WHERE PostID Like %ld", (long)post.ID]];
    if ([array count] == 0) {
        return [[RatingModel alloc] init];
    }
    NSArray *firstRatingArray = [array objectAtIndex:0];
    RatingModel *rating = [[RatingModel alloc] initWithDBArray:firstRatingArray];
    return rating;
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
