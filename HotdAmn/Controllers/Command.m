//
//  Command.m
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

enum {
    ArgTypeAny,
    ArgTypePrivclass,
    ArgTypeUsername
};

static NSNumber *argTypeAny() { return [NSNumber numberWithInt:ArgTypeAny]; }
static NSNumber *argTypePrivclass() { return [NSNumber numberWithInt:ArgTypePrivclass]; }
static NSNumber *argTypeUsername() { return [NSNumber numberWithInt:ArgTypeUsername]; }

@implementation Command

+ (NSDictionary *)commands
{
    static NSDictionary *cmds;
    if (!cmds) {
        cmds = [[NSDictionary dictionaryWithObjectsAndKeys:
                [NSArray arrayWithObject:argTypeAny()], @"join",
                [NSArray arrayWithObject:argTypeAny()], @"part", 
                [NSArray arrayWithObject:argTypeUsername()], @"kick",
                [NSArray arrayWithObject:argTypeUsername()], @"ban", nil] retain];
    }
    return cmds;
}

@end
