//
//  TagCellView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/31/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "TagCellView.h"

@implementation TagCellView {
    TagModel *tag;
}

-(id) initWithFrame:(CGRect)frame andTag:(TagModel *)tg {
    self = [[[NSBundle mainBundle] loadNibNamed:@"TagCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    tag = tg;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    float padding = 0.05 * self.frame.size.height;
    float height = self.frame.size.height - (2 * padding);
    float width = self.frame.size.width - (2 * padding);
    
    float yPos = self.frame.size.height / 2;
    float xPos = self.frame.size.width / 2;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, padding)];
    container.center = CGPointMake(yPos, xPos);
    container.backgroundColor = [UIColor blackColor];
    [self addSubview:container];
    
    yPos = container.frame.size.height / 2;
    width = 0.8 * container.frame.size.height;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    numberLabel.text = [NSString stringWithFormat:@"%ld", (long)tag.number];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.center = CGPointMake(numberLabel.frame.size.width, yPos);
    [container addSubview:numberLabel];
    
    xPos = numberLabel.frame.size.width + numberLabel.frame.origin.x + 8;
    width = container.frame.size.width - xPos;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, container.frame.size.height)];
    titleLabel.text = tag.title;
    titleLabel.textColor = [UIColor whiteColor];
    [container addSubview:titleLabel];
}

@end
