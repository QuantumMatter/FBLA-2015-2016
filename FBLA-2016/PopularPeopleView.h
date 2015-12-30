//
//  PopularPeopleView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "UserModel.h"

@interface PopularPeopleView : UIView <UserModelDelegate>

@property NSMutableArray *users;
@property NSMutableArray *orderedUsers;
@property NSMutableArray *userViews;

-(id) initWithFrame:(CGRect)frame;

-(void) activateView;
-(void) deactivateView;

-(void) userSwiped:(UIPanGestureRecognizer *)recog;

@end
