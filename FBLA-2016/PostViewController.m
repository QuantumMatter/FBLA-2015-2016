//
//  PostViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "PostViewController.h"
#import "ImagePostView.h"
#import "PostModel.h"

@interface PostViewController ()

@end

@implementation PostViewController {
    NSMutableArray *imagePostViews;
    NSMutableArray *images;
    
    UIImageView *selector;
    
    UIScrollView *scrollView;
    
    NSURLConnection *uploadConn;
    NSURLConnection *postConn;
    NSURLConnection *imagePostConn;
    
    NSString *imagePath;
    PostModel *newPost;
    
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagePostViews = [[NSMutableArray alloc] init];
    images = [[NSMutableArray alloc] init];
    
    [self loadComponents];
}

-(void) loadComponents {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:view];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    [view addSubview:scrollView];
    scrollView.clipsToBounds = NO;
    
    ImagePostView *imagePostView = [[ImagePostView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.height, scrollView.frame.size.height) forNewPost:1];
    imagePostView.delegate = self;
    [scrollView addSubview:imagePostView];
    [imagePostViews addObject:imagePostView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedScrollView:)];
    [scrollView addGestureRecognizer:tap];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [imagePostViews count], scrollView.frame.size.height);
}

-(void) userTappedScrollView:(UITapGestureRecognizer *)tap {
    NSLog(@"User Tapped");
    for (int i = 0; i < [imagePostViews count]; i++) {
        ImagePostView *view = [imagePostViews objectAtIndex:i];
        UIImageView *tempImage = [view imageForTap:tap];
        if (tempImage != nil) {
            [self userSelectedImage:tempImage];
        }
    }
}

-(void) userSelectedImage:(UIImageView *)view {
    if ([view.image isEqual:[UIImage imageNamed:@"camera.png"]]) {
        NSLog(@"Camera Pic Selected");
        selector = view;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Picture"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        [actionSheet showInView:self.view];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 1) {
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
    }
    NSString *string = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
    NSLog(string);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.tabBarController presentViewController:picker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    selector.image = image;
    [images addObject:image];
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)postPressed:(id)sender {
    NSLog(@"Post Pressed");
    
    for (int i = 0; i < [images count]; i++) {
        NSData *data = UIImageJPEGRepresentation([images objectAtIndex:i], 0.1);
        [self uploadimage:data];
    }
}

-(IBAction)cancelPressed:(id)sender {
    NSLog(@"Cancel Presed");
    [UIView animateWithDuration:0.5 animations:^{
        [self loadComponents];
    }];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(dataString);
    if (connection == uploadConn) {
        [self uploadNewPost];
        NSArray *comp = [dataString componentsSeparatedByString:@"\\"];
        imagePath = [NSString stringWithFormat:@"http://24.8.58.134/FocalPoint/Images/%@.jpg", [comp lastObject]];
        NSLog(imagePath);
    }
    if (connection == postConn) {
        newPost = [[PostModel alloc] initWithDBData:data];
        [self postImagePost];
    }
    if (connection == imagePostConn) {
        NSLog(@"Post Successful");
    }
}

-(void) uploadimage:(NSData *)imageData {
    NSString *urlString = @"http://24.8.58.134/FocalPoint/API/Upload";
    NSString *filename = @"filename";
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    uploadConn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void) uploadNewPost {
    UserModel *user = [self getCurrentUser];
    NSString *dataString = [NSString stringWithFormat:@"UserID=%ld&DatePosted=01/04/2016", user.ID];
    NSURL *URL = [NSURL URLWithString:@"http://24.8.58.134/FocalPoint/API/PostsAPI/"];
    NSMutableURLRequest *request = [self postRequestFor:URL withDataString:dataString];
    postConn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(UserModel *) getCurrentUser {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    docPath = [docPath stringByAppendingPathComponent:@"FBLA Users"];
    
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    UserModel *save = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return save;
}

-(void) postImagePost {
    NSString *dataString = [NSString stringWithFormat:@"PostID=%ld&Source=%@&Type=1", (long)newPost.ID, imagePath];
    NSURL *URL = [NSURL URLWithString:@"http://24.8.58.134/FocalPoint/API/ImagePostsAPI/"];
    NSMutableURLRequest *request = [self postRequestFor:URL withDataString:dataString];
    imagePostConn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
