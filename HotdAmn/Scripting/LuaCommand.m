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
    return self;
}

- (void)execute
{
    NSLog(@"trying execution");
    NSLog(@"%@", [LuaInterop lua]);
}

+ (void)addCommand:(LuaCommand *)cmd
{
    if (cmds == nil) {
        cmds = [[NSMutableDictionary dictionary] retain];
    }
    [cmds setObject:cmd forKey:[cmd name]];
}

+ (NSMutableDictionary *)commands
{
    return cmds;
}

+ (LuaCommand *)commandWithName:(NSString *)name
{
    return [cmds objectForKey:name];
}

@end
