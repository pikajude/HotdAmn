//
//  UserAction.m
//  HotdAmn
//
//  Created by Joel on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAction.h"

@implementation UserAction

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)cssClasses
{
    return [NSString stringWithFormat:@"%@ action", [super cssClasses]];
}

@end
