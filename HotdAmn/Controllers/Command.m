//
//  Command.m
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

static NSNumber *argTypeAny() { return [NSNumber numberWithInt:ArgTypeAny]; }
static NSNumber *argTypePrivclass() { return [NSNumber numberWithInt:ArgTypePrivclass]; }
static NSNumber *argTypeUsername() { return [NSNumber numberWithInt:ArgTypeUsername]; }
static NSNumber *argTypeRoom() { return [NSNumber numberWithInt:ArgTypeRoom]; }

@implementation Command

@synthesize arity, command, types;

+ (Command *)commandWithBlock:(commandBlock)block arity:(NSInteger)ar types:(int [])types
{
    Command *c = [[[Command alloc] init] autorelease];
    [c setCommand:block];
    [c setArity:ar];
    NSMutableArray *t = [NSMutableArray array];
    if (types) {
        for (int i = 0; i < abs((int)ar); i++) {
            [t addObject:[NSNumber numberWithInt:types[i]]];
        }
    }
    [c setTypes:t];
    return c;
}

+ (NSDictionary *)allCommands
{
    static NSDictionary *cmds;
    if (!cmds) {
        cmds = [[NSDictionary dictionaryWithObjectsAndKeys:
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args) {
    for (NSString *room in args) {
        [receiver join:room];
    }
} arity:-1 types:(int[]){ ArgTypeAny }], @"join",
                 
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args) {
    NSString *str = [args componentsJoinedByString:@" "];
    [receiver action:str inRoom:[caller roomName]];
} arity:-1 types:(int[]){ ArgTypeUsername | ArgTypeRoom }], @"me",
                 
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args) {

} arity:-2 types:(int[]){ ArgTypeUsername, ArgTypeAny }], @"kick",
                 
                 nil] retain];
    }
    return cmds;
}

- (void)dealloc
{
    [command release];
    [types release];
    [super dealloc];
}

@end
