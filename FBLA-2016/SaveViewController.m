//
//  SaveViewController.m
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "SaveViewController.h"
#import "SaveTest.h"

@interface SaveViewController ()

@end

@implementation SaveViewController {
    
    IBOutlet UITextField *fieldOne;
    IBOutlet UILabel *fieldTwo;
    
    SaveTest *saveTest;
    IBOutlet UIStepper *stepper;
    
    NSString *docPath;
}

-(IBAction)decrease:(UIStepper *)sender {
    double value = [sender value];
    fieldTwo.text = [NSString stringWithFormat:@"%f", value];
}

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

- (IBAction)submit:(UIButton *)sender {
    [saveTest setFieldOne:fieldOne.text];
    [saveTest setFieldTwo:[fieldTwo.text doubleValue]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir = [documentsDir stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of directory: %@", [error localizedDescription]);
        return;
    }
    
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"SaveTest" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    NSString *availableName = [NSString stringWithFormat:@"%d.SaveTest", maxNumber+1];
    docPath = [documentsDir stringByAppendingPathComponent:availableName];
    
    error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //NSMutableData *_data = [[NSMutableData alloc] init];
    [archiver encodeObject:saveTest forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

-(SaveTest *) data {
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    SaveTest *save = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return save;
}

- (IBAction)loadPressed:(id)sender {
    @try {
        saveTest = [self data];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Thrown");
    }
    @finally {
        if (saveTest == nil) {
            saveTest = [[SaveTest alloc] initWithFieldOne:fieldOne.text andFieldTwo:stepper.value];
        }
        fieldOne.text = [saveTest getFieldOne];
        fieldTwo.text = [NSString stringWithFormat:@"%f", [saveTest getFieldTwo]];
        stepper.value = [saveTest getFieldTwo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        saveTest = [self data];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception thrown");
    }
    @finally {
        if (saveTest == nil) {
            saveTest = [[SaveTest alloc] init];
        }
    }
    
    fieldOne.text = [saveTest getFieldOne];
    fieldTwo.text = [NSString stringWithFormat:@"%f", [saveTest getFieldTwo]];
    stepper.value = [saveTest getFieldTwo];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) viewDidDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
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
