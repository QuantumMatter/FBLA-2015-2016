//
//  CommentCellView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCellView : UIView <UIGestureRecognizerDelegate>

-(id) initWithFrame:(CGRect)frame andComment:(CommentModel *)comm;

-(id) initForNewCommentWithFrame:(CGRect)frame;

@end
