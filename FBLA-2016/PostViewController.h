//
//  PostViewController.h
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePostView.h"

@interface PostViewController : UIViewController <ImagePostDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end
