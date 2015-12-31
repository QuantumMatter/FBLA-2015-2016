//
//  TagIconView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/31/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "TagIconView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TagIconView {
    NSInteger number;
}

-(id) initWIthNumber:(NSInteger)num {
    self = [[[NSBundle mainBundle] loadNibNamed:@"TagIconView" owner:self options:nil] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, 25, 25);
    number = num;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    UIView *outerRing = [[UIView alloc] initWithFrame:self.frame];
    outerRing.backgroundColor = [UIColor purpleColor];
    outerRing.layer.cornerRadius = outerRing.frame.size.width / 2;
    [self addSubview:outerRing];
    
    float adjSize = 0.8 * self.frame.size.width;
    UIView *innerRing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adjSize, adjSize)];
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    innerRing.center = center;
    innerRing.backgroundColor = [UIColor whiteColor];
    [self addSubview:innerRing];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:self.frame];
    numberLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
    numberLabel.center = center;
    [self addSubview:numberLabel];
}

@end
