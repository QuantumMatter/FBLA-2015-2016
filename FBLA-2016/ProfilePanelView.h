//
//  ProfilePanelView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol ProfilePanelDelegate <NSObject>

-(void) panelSelected:(id)sender;

@end

@interface ProfilePanelView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *profilePicView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *followLabel;
@property UserModel *user;

@property id<ProfilePanelDelegate> delegate;

-(id) init;

-(id) initWithUser:(UserModel *)userModel;

@end
