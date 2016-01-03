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
#import "DBManager.h"

@implementation ProfileView {
    NSString *docPath;
    
    NSInteger userID;
    UserModel *user;
    
    SlidingViewController *slidingView;
    
    UIView *myPostsView;
    UIView *myCommentsView;
    CGRect slidingViewFrame;
    
    DBManager *manager;
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@synthesize parentController;

-(id) initWithFrame:(CGRect)frame andUser:(NSInteger)uID {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    userID = uID;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    user = [[UserModel alloc] initWithID:userID];
    
    float yPos = 50;
    
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
    nameLabel.font = [nameLabel.font fontWithSize:25];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.frame.size.width / 2, yPos += (nameLabel.frame.size.height / 2));
    [self addSubview:nameLabel];
    yPos += nameLabel.frame.size.height;
    
    CGRect frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - yPos);
    myPostsView = [[UIView alloc] initWithFrame:frame];
    myCommentsView = [[UIView alloc] initWithFrame:frame];
    
    [self loadMyComments];
    [self loadMyPosts];
    
    myPostsView.backgroundColor = [UIColor redColor];
    
    slidingViewFrame = CGRectMake(0, yPos, view.frame.size.width, view.frame.size.height - yPos);
    slidingView = [[SlidingViewController alloc] initWithFrame:slidingViewFrame andDelegate:self];
    [self addSubview:slidingView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:slidingView action:@selector(swiped:)];
    [slidingView addGestureRecognizer:pan];
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
    scrollView.clipsToBounds = NO;
    
    float yPos = 70;
    
    for (int i = 0; i < [posts count]; i++) {
        PostModel *post = [posts objectAtIndex:i];
        CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 75);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedPostCell:)];
        PostCellView *postCell = [[PostCellView alloc] initWithFrame:frame andPost:post];
        [postCell addGestureRecognizer:tap];
        postCell.delegate = self;
        [scrollView addSubview:postCell];
        yPos += 8 + postCell.frame.size.height;
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    [myPostsView addSubview:scrollView];
}

-(NSMutableArray *) getMyPosts {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM Posts WHERE UserID LIKE %ld", userID]];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSArray *postArray = [array objectAtIndex:i];
        PostModel *post = [[PostModel alloc] initWithPostArray:postArray];
        [posts addObject:post];
    }
    
    return posts;
}

-(void) loadMyComments {
    NSMutableArray *comments = [self getMyComments];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, slidingViewFrame.size.height)];
    scrollView.clipsToBounds = NO;
    
    float yPos = 70;
    
    for (int i = 0; i < [comments count]; i++) {
        CommentModel *comment = [comments objectAtIndex:i];
        CGRect frame = CGRectMake(0, yPos, self.frame.size.width, 75);
        CommentCellView *commentCell = [[CommentCellView alloc] initWithFrame:frame andComment:comment];
        commentCell.frame = frame;
        [scrollView addSubview:commentCell];
        yPos += 8 + commentCell.frame.size.height;
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, yPos);
    
    [myCommentsView addSubview:scrollView];
}

-(NSMutableArray *) getMyComments {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    
    NSArray *array = [manager loadDataFromDB:[NSString stringWithFormat:@"SELECT * FROM Comments WHERE UserID LIKE %ld", userID]];
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        NSArray *postArray = [array objectAtIndex:i];
        CommentModel *comment = [[CommentModel alloc] initWithDBArray:postArray];
        [comments addObject:comment];
    }
    
    return comments;
}

-(void) userTappedPostCell:(id)sender {
    NSLog(@"User Tapped Post Cell");
    
}

@end
