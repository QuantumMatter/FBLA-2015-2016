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
#import "SlidingViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController {
    DBManager *manager;
    
    NSMutableArray *views;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(raiseViewForKeyboard)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lowerViewForKeyboard)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    [self loadPostViews];
    SlidingViewController *slidingView = [[SlidingViewController alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:slidingView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:slidingView action:@selector(swiped:)];
    [self.view addGestureRecognizer:pan];
    
    [self dontSwallow:self.view];
}

-(NSString *) titleForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return @" ";
}

-(UIView *) viewForIndex:(NSInteger)index forSlidingView:(UIView *)slidingView {
    return [views objectAtIndex:index];
}

-(NSInteger) numberOfViewsInSlidingView:(UIView *)slidingView {
    return [views count];
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

-(void) loadPostViews {
    NSMutableArray *posts = [self getMyPosts];
    
    views = [[NSMutableArray alloc] init];
    for (int i = 0; i < [posts count]; i++) {
        PostModel *post = [posts objectAtIndex:i];
        CGRect interPostFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height); //self.view.frame;
        CGRect postFrame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width);
        PostView *postView = [[PostView alloc] initWithFrame:interPostFrame andPost:post];
        postView.frame = postFrame;
        [views addObject:postView];
    }
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

-(void) raiseViewForKeyboard {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -(self.view.frame.size.height / 2), self.view.frame.size.width, self.view.frame.size.height);
    }];
}


-(void) lowerViewForKeyboard {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
