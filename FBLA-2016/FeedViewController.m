//
//  FeedViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "FeedViewController.h"
#import "DBManager.h"
#import "PostModel.h"
#import "PostView.h"

@interface FeedViewController ()

@end

@implementation FeedViewController {
    DBManager *manager;
    
    UIScrollView *postScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    postScroll = [self loadPostViews];
    postScroll.clipsToBounds = NO;
    self.view.clipsToBounds = NO;
    [self.view addSubview:postScroll];
    
    [self dontSwallow:self.view];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [gestureRecognizer locationInView:postScroll];
    float yPos = postScroll.contentSize.height - point.y;
    
    if (yPos < 50) {
        return NO;
    } else {
        return YES;
    }
}

-(void) dontSwallow:(UIView *)view {
    NSArray *subViews = view.subviews;
    NSArray *gestureRecognizers = view.gestureRecognizers;
    for (int a = 0; a < [gestureRecognizers count]; a++) {
        UIGestureRecognizer *gesture = [gestureRecognizers objectAtIndex:a];
        gesture.cancelsTouchesInView = NO;
    }
    for (int i = 0; i < [subViews count]; i++) {
        UIView *subView = [subViews objectAtIndex:i];
        [self dontSwallow:subView];
        NSArray *gestureRecognizers = subView.gestureRecognizers;
        for (int a = 0; a < [gestureRecognizers count]; a++) {
            UIGestureRecognizer *gesture = [gestureRecognizers objectAtIndex:a];
            gesture.cancelsTouchesInView = NO;
            gesture.enabled = YES;
            @try {
                gesture.delegate = self;
            }
            @catch (NSException *exception) {
                NSLog(@"Excpetion Caught");
            }
            @finally {
                
            }
        }
    }
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *) loadPostViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    NSMutableArray *posts = [self getMyPosts];
    
    NSMutableArray *postViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < [posts count]; i++) {
        PostModel *post = [posts objectAtIndex:i];
        PostView *postView = [[PostView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) andPost:post];
        [postViews addObject:postView];
        scrollView.contentSize = CGSizeMake((i+1) * self.view.frame.size.width, self.view.frame.size.height);
        [scrollView addSubview:postView];
    }
    return scrollView;
}

-(NSMutableArray *) getMyPosts {
    if (manager == nil) {
        manager = [[DBManager alloc] initWithDatabaseFilename:@"fbla.sqlite"];
    }
    NSArray *array = [manager loadDataFromDB:@"SELECT * FROM Posts"];
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++) {
        PostModel *post = [[PostModel alloc] initWithPostArray:[array objectAtIndex:i]];
        [posts addObject:post];
    }
    return posts;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
