//
//  LuaCommand.m
//  HotdAmn
//
//  Created by Joel on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaCommand.h"
#import "LuaInterop.h"

static NSMutableDictionary *cmds;

@implementation LuaCommand

@synthesize arity;
@synthesize types = _types;
@synthesize name;

- (id)initWithIndex:(int)index commandName:(NSString *)n
{
    self = [super init];
    regindex = index;
    name = n;
    _types = [[NSArray array] retain];
    arity = 0;
    return self;
}

- (void)executeWithArgs:(NSArray *)args
{
    [[LuaInterop lua] executeRegistryFunction:regindex withObject:args];
}

+ (BOOL)addCommand:(LuaCommand *)cmd
{
    if (cmds == nil) {
        cmds = [[NSMutableDictionary dictionary] retain];
    }
    if ([cmds objectForKey:[cmd name]] != nil) {
        return NO;
    }
    [cmds setObject:cmd forKey:[cmd name]];
    return YES;
}

+ (void)reset
{
    [cmds release];
    cmds = nil;
}

+ (NSMutableDictionary *)commands
{
    return cmds;
}

+ (LuaCommand *)commandWithName:(NSString *)name
{
    return [cmds objectForKey:name];
}

- (void)dealloc
{
    [_types release];
    [super dealloc];
}

@end
