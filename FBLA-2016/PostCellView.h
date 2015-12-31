//
//  PostCellView.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostModel.h"

@protocol PostCellDelegate <NSObject>

-(void) userTappedPostCell:(id)sender;

@end

@interface PostCellView : UIView

-(id) initWithFrame:(CGRect)frame andPost:(PostModel *)pModel;

@property NSMutableArray *ratings;

@property id<PostCellDelegate> delegate;

@end
