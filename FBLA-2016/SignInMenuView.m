//
//  SignInMenuView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/21/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "SignInMenuView.h"

@implementation SignInMenuView

-(id) init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SignInMenuView" owner:self options:nil] objectAtIndex:0];
    return self;
}

@end
