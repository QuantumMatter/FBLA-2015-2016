//
//  PopularPeopleView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PopularPeopleView.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation PopularPeopleView {
    UIView *circleContainer;
    
    BOOL viewIsActive;
    
    CGPoint firstPoint;
    CGRect firstFrame;
}

@synthesize users;
@synthesize userViews;
@synthesize orderedUsers;

-(id) initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"RegisterViews" owner:self options:nil] objectAtIndex:2];
    self.frame = frame;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    users = [[NSMutableArray alloc] init];
    userViews = [[NSMutableArray alloc] init];
    orderedUsers = [[NSMutableArray alloc] init];
    
    viewIsActive = NO;
    
    circleContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:circleContainer];
    
    self.clipsToBounds = YES;
    
    UserModel *user1 = [[UserModel alloc] init];
    [user1 test1];
    user1.delegate = self;
    [users addObject:user1];
    
    UserModel *user2 = [[UserModel alloc] init];
    user2.delegate = self;
    [user2 test2];
    [users addObject:user2];
    
    UserModel *user3 = [[UserModel alloc] init];
    user3.delegate = self;
    [user3 test3];
    [users addObject:user3];
    
    UserModel *user4 = [[UserModel alloc] init];
    user4.delegate = self;
    [user4 test4];
    [users addObject:user4];
    
    [users sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UserModel *userA = (UserModel *)obj1;
        double distanceA = userA.followers;
        
        UserModel *userB = (UserModel *)obj2;
        double distanceB = userB.following;
        
        NSDate *dateB = [[NSDate alloc] initWithTimeIntervalSince1970:distanceB];
        NSDate *dateA = [[NSDate alloc] initWithTimeIntervalSince1970:distanceA];
        
        return [dateA compare:dateB];
    }];
    
    NSInteger length = MIN(100, [users count]);
    for (int i = 0; i < length; i++) {
        [orderedUsers addObject:[users objectAtIndex:i]];
    }
    
    double doubleCount = length;
    
    NSInteger sideLength = sqrt(doubleCount);
    UserModel *baseUserTest = [[UserModel alloc] init];
    [baseUserTest test1];
    UIView *base = [self roundedViewFromUser:baseUserTest];
    for (int x = 0; x < sideLength; x++) {
        circleContainer.frame = CGRectMake(0, 0, circleContainer.frame.size.width + (1.25 * base.frame.size.width), circleContainer.frame.size.height);
        for (int y = 0; y < sideLength; y++) {
            if (x == 0) {
                circleContainer.frame = CGRectMake(0, 0, circleContainer.frame.size.width, circleContainer.frame.size.height + (1.25 * base.frame.size.height));
            }
            NSInteger pos = sideLength * x;
            pos += y;
            
            UserModel *user = [orderedUsers objectAtIndex:pos];
            UIView *view = [self roundedViewFromUser:user];
            float xCoor = view.frame.size.width / 2 * 3 * x;
            float yCoor = view.frame.size.height / 2 * 3 * y;
            
            float xOffset = view.frame.size.width / 2;
            float yOffset = view.frame.size.height / 2;
            
            if (!((2 * ( y / 2)) == y)) {
                xOffset = view.frame.size.width * 1.25;
            }
            
            view.center = CGPointMake(xCoor + xOffset, yCoor + yOffset);
            [circleContainer addSubview:view];
        }
    }
    circleContainer.clipsToBounds = YES;
    //circleContainer.bounds = self.frame;
    circleContainer.frame = CGRectMake(0, 0, circleContainer.frame.size.width + base.frame.size.width, circleContainer.frame.size.height);
    circleContainer.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

-(UIView *) roundedViewFromUser:(UserModel * )user {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.image = user.profilePic;
    float size = imageView.frame.size.width;
    imageView.layer.cornerRadius = size / 2;
    return imageView;
}

-(void) zipFound:(id)sender {
    
}

-(void) activateView {
    viewIsActive = YES;
}

-(void) deactivateView {
    viewIsActive = NO;
}

-(void) userSwiped:(UIPanGestureRecognizer *)recog {
    if (viewIsActive) {
        if (recog.state == UIGestureRecognizerStateBegan) {
            firstPoint = [recog locationInView:self];
            firstFrame = circleContainer.frame;
        }
        CGPoint currentPoint = [recog locationInView:self];
        
        float deltaY = currentPoint.y - firstPoint.y;
        float deltaX = currentPoint.x - firstPoint.x;
        
        /*float originX = firstFrame.origin.x + deltaX;
        float originY = firstFrame.origin.y + deltaY;
        
        if (originX > 0) {
            deltaX = self.frame.size.width - circleContainer.frame.size.width;
        }
        if (originY > 0) {
            deltaY = self.frame.size.height - circleContainer.frame.size.height;
        }
        
        float oppX = originX + circleContainer.frame.size.width;
        float oppY = originY + circleContainer.frame.size.height;
        
        if (oppX < self.frame.size.width) {
            deltaX = 0;
        }
        if (oppY < self.frame.size.height) {
            deltaY = 0;
        }*/
        
        circleContainer.frame = CGRectMake(firstFrame.origin.x + deltaX, firstFrame.origin.y + deltaY, circleContainer.frame.size.width, circleContainer.frame.size.height);
    }
}

@end
