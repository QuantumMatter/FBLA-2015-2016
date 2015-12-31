//
//  ProfileView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "ProfileView.h"
#import "UserModel.h"
#import "SlidingViewController.h"
#import "DBManager.h"
#import "PostModel.h"
#import "PostCellView.h"
#import "CommentCellView.h"
#import "CommentModel.h"

@implementation ProfileView {
    NSString *docPath;
    
    NSInteger userID;
    UserModel *user;
    
    SlidingViewController *slidingView;
    
    UIView *myPostsView;
    UIView *myCommentsView;
    CGRect slidingViewFrame;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame andUser:(NSInteger)uID {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    userID = uID;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    user = [self getUserWithID:userID];
    
    float yPos = 0;
    
    UIView *view = self;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.center = CGPointMake(view.frame.size.width / 2, imageView.frame.size.height / 2 + 25 + yPos);
    imageView.image = user.profilePic;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    [view addSubview:imageView];
    yPos += imageView.frame.size.height + imageView.frame.origin.y;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, view.frame.size.width, 30)];
    NSString *name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    nameLabel.text = name;
    [self addSubview:nameLabel];
    yPos += nameLabel.frame.size.height;
    
    CGRect frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - yPos);
    myPostsView = [[UIView alloc] initWithFrame:frame];
    myCommentsView = [[UIView alloc] initWithFrame:frame];
    
    [self loadMyComments];
    [self loadMyPosts];
    
    slidingViewFrame = CGRectMake(0, yPos, view.frame.size.width, view.frame.size.height - yPos);
    slidingView = [[SlidingViewController alloc] initWithFrame:slidingViewFrame andDelegate:self];
    [self addSubview:slidingView];
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    UIView *view;
    switch (index) {
        case 0:
            view = myPostsView;
            break;
            
        case 1:
            view = myCommentsView;
            break;
            
        default:
            break;
    }
    return view;
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return 2;
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    NSString *title;
    switch (index) {
        case 0:
            title = @"Posts";
            break;
            
        case 1:
            title = @"Comments";
            break;
            
        default:
            break;
    }
    return title;
}

-(UserModel *) getUserWithID:(NSInteger)uID {
    UserModel *userModel = [[UserModel alloc] init];
    [userModel test1];
    return userModel;
}

-(void) loadMyPosts {
    NSMutableArray *posts = [self getMyPosts];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, slidingViewFrame.size.height)];
    
    float yPos = 8;
    
    for (int i = 0; i < [posts count]; i++) {
        PostModel *post = [posts objectAtIndex:i];
        CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 150);
        PostCellView *postCell = [[PostCellView alloc] initWithFrame:frame andPost:post];
        postCell.delegate = self;
        [scrollView addSubview:postCell];
        yPos += 8 + postCell.frame.size.height;
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    [myPostsView addSubview:scrollView];
}

-(NSMutableArray *) getMyPosts {
    return nil;
}

-(void) loadMyComments {
    NSMutableArray *comments = [self getMyComments];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, slidingViewFrame.size.height)];
    
    float yPos = 8;
    
    for (int i = 0; i < [comments count]; i++) {
        CommentModel *comment = [comments objectAtIndex:i];
        CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 150);
        CommentCellView *commentCell = [[CommentCellView alloc] initWithFrame:frame andComment:comment];
        commentCell.frame = frame;
        [scrollView addSubview:commentCell];
        yPos += 8 + commentCell.frame.size.height;
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    [myCommentsView addSubview:scrollView];
}

-(NSMutableArray *) getMyComments {
    return nil;
}

-(void) userTappedPostCell:(id)sender {
    NSLog(@"User Tapped Post Cell");
}

@end
