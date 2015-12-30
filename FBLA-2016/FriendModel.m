//
//  FriendModel.m
//  FBLA-2016
//
//  Created by David Kopala on 12/30/15.
//  Copyright © 2015 David Kopala. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

@synthesize ID;

@synthesize user;
@synthesize userID;

@synthesize Friend;
@synthesize friendID;

-(id) initWithUser:(NSInteger)uID andFriend:(NSInteger)fID {
    self = [super init];
    
    ID = -1;
    userID = uID;
    friendID = fID;
    
    return self;
}

-(void) pushToServer {
    
}

@end
