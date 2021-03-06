//
//  CommentCellView.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "CommentCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommentCellView {
    CommentModel *comment;
    
    UITextField *newComment;
    
    NSInteger postID;
}

-(id) initWithFrame:(CGRect)frame andComment:(CommentModel *)comm {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    comment = comm;
    [self loadComponents];
    return self;
}

-(void) loadComponents {
    float midY = self.frame.size.height / 2;
    float xSpace = 0.15 * self.frame.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * self.frame.size.height, 0.8 * self.frame.size.height)];
    imageView.image = comment.user.profilePic;
    imageView.center = CGPointMake(midY, midY);
    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * xSpace, 0.1 * self.frame.size.height, 0.65 * self.frame.size.width, 0.8 * self.frame.size.height)];
    label.text = comment.comment;
    [self addSubview:label];
}

-(id) initForNewCommentWithFrame:(CGRect)frame withPostID:(NSInteger)ID {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentCellView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    postID = ID;
    
    float midY = self.frame.size.height / 2;
    float xSpace = 0.15 * self.frame.size.width;
    
    UserModel *currUser = [self getCurrentUser];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * self.frame.size.height, 0.8 * self.frame.size.height)];
    imageView.image = currUser.profilePic;
    imageView.center = CGPointMake(midY, midY);
    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
    [self addSubview:imageView];
    
    newComment = [[UITextField alloc] initWithFrame:CGRectMake(2 * xSpace, 0.1 * self.frame.size.height, 0.5 * self.frame.size.width, 0.8 * self.frame.size.height)];
    newComment.placeholder = @"Comment";
    [self addSubview:newComment];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    float xOrigin = newComment.frame.origin.x + newComment.frame.size.width;
    button.frame = CGRectMake(xOrigin, 0, self.frame.size.width - xOrigin, self.frame.size.height);
    [button setTitle:@"GO" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendNewComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return self;
}

-(void) sendNewComment {
    NSLog(@"Submit New Comment");
    [self endEditing:YES];
    NSURL *URL = [NSURL URLWithString:@"http://24.8.58.134/FocalPoint/API/CommentsAPI/"];
    UserModel *user = [self getCurrentUser];
    NSString *dataString = [NSString stringWithFormat:@"Comment=%@&PostID=%ld&UserID=%ld", newComment.text, (long)postID, (long)user.ID];
    NSMutableURLRequest *request = [self postRequestFor:URL withDataString:dataString];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
}

-(NSMutableURLRequest *) postRequestFor:(NSURL *)url withDataString:(NSString *)string {
    NSData *postData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init ];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return request;
}

-(UserModel *) getCurrentUser {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    NSString *dataPath = [docPath stringByAppendingPathComponent:@"data.plist"];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    UserModel *save = [unarchiver decodeObjectForKey:@"Data"];
    [unarchiver finishDecoding];
    
    return save;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
