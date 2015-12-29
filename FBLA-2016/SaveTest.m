//
//  SaveTest.m
//  FBLA-2016
//
//  Created by David Kopala on 12/28/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "SaveTest.h"

@implementation SaveTest {
    NSString *fieldOne;
    double fieldTwo;
}

#define kFieldOne       @"FieldOne"
#define kFieldTwo       @"FieldTwo"

-(id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    fieldOne = [decoder decodeObjectForKey:kFieldOne];
    fieldTwo = [decoder decodeDoubleForKey:kFieldTwo];
    return self;
}

-(id) initWithFieldOne:(NSString *)fieldA andFieldTwo:(NSInteger)fieldB {
    self = [super init];
    fieldOne = fieldA;
    fieldTwo = fieldB;
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:fieldOne forKey:kFieldOne];
    [encoder encodeDouble:fieldTwo forKey:kFieldTwo];
}

-(NSString *)getFieldOne {
    return fieldOne;
}

-(double) getFieldTwo {
    return fieldTwo;
}

-(void) setFieldOne:(NSString *)fieldA {
    fieldOne = fieldA;
}

-(void) setFieldTwo:(double)fieldB {
    fieldTwo = fieldB;
}

@end
