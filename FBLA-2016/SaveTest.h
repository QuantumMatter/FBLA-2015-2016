//
//  SaveTest.h
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveTest : NSObject <NSCoding>

-(id) initWithFieldOne:(NSString *)fieldA andFieldTwo:(NSInteger)fieldB;

-(NSString *)getFieldOne;
-(double) getFieldTwo;

-(void) setFieldOne:(NSString *)fieldA;
-(void) setFieldTwo:(double) fieldB;

@end
