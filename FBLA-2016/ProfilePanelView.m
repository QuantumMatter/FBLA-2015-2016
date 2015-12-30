//
//  ProfilePanelView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/29/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "ProfilePanelView.h"

@implementation ProfilePanelView {
    UITapGestureRecognizer *tap;
}

@synthesize followLabel;
@synthesize nameLabel;
@synthesize profilePicView;
@synthesize user;

-(id) init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ProfilePanelView" owner:self options:nil] objectAtIndex:0];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followTapped:)];
    [nameLabel addGestureRecognizer:tap];
    
    return self;
}

-(id) initWithUser:(UserModel *)userModel {
    self = [self init];
    user = userModel;
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    nameLabel.text = name;
    
    profilePicView.image = user.profilePic;
    
    return self;
}

-(void) followTapped:(UITapGestureRecognizer *)tapped {
    if (tapped == tap) {
        if (tapped.state == UIGestureRecognizerStateEnded) {
            NSLog(@"Follow Tapped");
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
