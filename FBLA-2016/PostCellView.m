//
//  PostCellView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PostCellView.h"
#import "ImagePostModel.h"
#import <QuartzCore/QuartzCore.h>
#import "RatingModel.h"
#import "ImagePostView.h"

@implementation PostCellView {
    PostModel *post;
    
    RatingModel *avgRating;
}

@synthesize ratings;
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame andPost:(PostModel *)pModel {
    self = [[[NSBundle mainBundle] loadNibNamed:@"PostCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    post = pModel;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    [self loadRatings];
    
    float yPos = self.frame.size.height / 2;
    float xPos = yPos;
    
    float ySize = 0.8 * self.frame.size.height;
    float xSize = 0.8 * self.frame.size.width;
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, ySize, ySize)];
    pic.center = CGPointMake(xPos, yPos);
    ImagePostView *imagePost = [post.imageViews objectAtIndex:0];
    UIImageView *imageView = [imagePost.subviews objectAtIndex:0];
    pic.image = imageView.image;               
    [self addSubview:pic];
    
    xSize *= 0.75;
    ySize *= 0.75;
    
    float space = 0.2 * self.frame.size.width;
    xPos += space;
    
    UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, ySize, ySize)];
    appLabel.text = [NSString stringWithFormat:@"%ld", (long)avgRating.appRating];
    appLabel.textAlignment = NSTextAlignmentCenter;
    appLabel.font = [appLabel.font fontWithSize:25];
    [appLabel sizeToFit];
    appLabel.center = CGPointMake(appLabel.center.x, self.frame.size.height / 2);
    [self addSubview:appLabel];
    
    xPos += space;
    
    UILabel *proRating = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, ySize, ySize)];
    proRating.text = [NSString stringWithFormat:@"%ld", (long)avgRating.overallRating];
    proRating.textAlignment = NSTextAlignmentCenter;
    proRating.font = appLabel.font;
    [proRating sizeToFit];
    proRating.center = CGPointMake(proRating.center.x, self.frame.size.height / 2);
    [self addSubview:proRating];
    
    xPos += space;
    
    UILabel *styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, ySize, ySize)];
    styleLabel.text = [NSString stringWithFormat:@"%ld", (long)avgRating.styleRating];
    styleLabel.textAlignment = NSTextAlignmentCenter;
    styleLabel.font = appLabel.font;
    [styleLabel sizeToFit];
    styleLabel.center = CGPointMake(styleLabel.center.x, self.frame.size.height / 2);
    [self addSubview:styleLabel];
    
    xPos += space;
    
    UILabel *ovLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, ySize, ySize)];
    ovLabel.text = [NSString stringWithFormat:@"%ld", (long)avgRating.overallRating];
    ovLabel.textAlignment = NSTextAlignmentCenter;
    ovLabel.font = appLabel.font;
    [ovLabel sizeToFit];
    ovLabel.center = CGPointMake(ovLabel.center.x, self.frame.size.height / 2);
    [self addSubview:ovLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

-(void) loadRatings {
    
}

-(void) calculateRatings {
    avgRating = [[RatingModel alloc] init];
    
    NSInteger appRating = 0;
    NSInteger appRatingCount = 0;
    
    NSInteger proRating = 0;
    NSInteger proRatingCount = 0;
    
    NSInteger styleRating = 0;
    NSInteger styleRatingCount = 0;
    
    NSInteger ovRating = 0;
    NSInteger ovRatingCount = 0;
    
    for (int i = 0; i < [ratings count]; i++) {
        RatingModel *rating = [ratings objectAtIndex:i];
        
        if (rating.appRating != -1) {
            appRating += rating.appRating;
            appRatingCount++;
        }
        if (rating.proRating != -1) {
            proRating += rating.proRating;
            proRatingCount++;
        }
        if (rating.styleRating != -1) {
            styleRating += rating.styleRating;
            styleRatingCount++;
        }
        if (rating.overallRating != -1) {
            ovRating += rating.overallRating;
            ovRatingCount++;
        }
    }
    avgRating.appRating = (appRating / appRatingCount);
    avgRating.proRating = (proRating / proRatingCount);
    avgRating.styleRating = (styleRating / styleRatingCount);
    avgRating.overallRating = (ovRating / ovRatingCount);
}

-(void) userTapped:(UITapGestureRecognizer *)recog {
    if (recog.state == UIGestureRecognizerStateEnded) {
        NSLog(@"User Tapped Post Cell");
        [delegate userTappedPostCell:self];
    }
}

@end
