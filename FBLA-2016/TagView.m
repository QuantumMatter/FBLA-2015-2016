//
//  TagView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/31/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "TagView.h"
#import "TagModel.h"
#import "TagCellView.h"

@implementation TagView {
    NSInteger postID;
}

-(id) initWithFrame:(CGRect)frame andPostID:(NSInteger)pID {
    self = [[[NSBundle mainBundle] loadNibNamed:@"TagView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    postID = pID;
    return self;
}

-(void) loadComponents {
    UIScrollView *container = [[UIScrollView alloc] initWithFrame:self.frame];
    
    NSMutableArray *tags = [self getMyTags];
    float xPos = 0;
    float width = self.frame.size.height * 3;
    
    for (int i = 0; i < [tags count]; i++) {
        TagModel *tag = [tags objectAtIndex:i];
        TagCellView *tagCell = [[TagCellView alloc] initWithFrame:CGRectMake(xPos, 0, width, self.frame.size.height) andTag:tag];
        xPos += tagCell.frame.size.width;
        [container addSubview:tagCell];
    }
    
    container.contentSize = CGSizeMake(xPos, self.frame.size.height);
    [self addSubview:container];
}

-(NSMutableArray *) getMyTags {
    return nil;
}

@end
