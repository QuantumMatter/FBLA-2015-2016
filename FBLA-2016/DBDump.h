//
//  DBDump.h
//  FBLA-2016
//
//  Created by David Kopala on 1/2/16.
//  Copyright © 2016 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBDump : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

-(id) initWithInterval:(NSInteger)time;

@end
