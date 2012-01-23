//
//  Command.m
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"
#import "BuddyCommand.h"

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

+ (Command *)commandWithType:(Class)type
{
    Command *c = [[[type alloc] init] autorelease];
    return c;
}

+ (NSDictionary *)allCommands
{
    static NSDictionary *cmds;
    if (!cmds) {
        cmds = [[NSDictionary dictionaryWithObjectsAndKeys:
// Join command
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args)
{
    for (NSString *room in args) {
        [receiver join:room];
    }
}
                    arity:-1
                    types:(int[]){ ArgTypeAny }], @"join",
                 
// Part command
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate> receiver, NSArray *args) {
    for (NSString *room in args) {
        [receiver part:room];
    }
}
                    arity:-1
                    types:(int[]){ ArgTypeRoom }], @"part",
                 
// Action command
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args)
{
    if ([args count] == 0) {
        NSBeep();
        return;
    }
    
    NSString *str = [args componentsJoinedByString:@" "];
    [receiver action:str inRoom:[caller roomName]];
}
                    arity:-1
                    types:(int[]){ ArgTypeUsername | ArgTypeRoom }], @"me",
                 
// Kick command
[Command commandWithBlock:^(Chat *caller, id<ChatDelegate>receiver, NSArray *args)
{
    if ([args count] == 0) {
        [caller userError:@"Not enough arguments to kick."];
        return;
    }
    if ([args count] > 1) {
        [receiver kick:[args objectAtIndex:0]
              fromRoom:[caller roomName]
            withReason:[[args subarrayWithRange:NSMakeRange(1, [args count] - 1)] componentsJoinedByString:@" "]];
    } else {
        [receiver kick:[args objectAtIndex:0]
              fromRoom:[caller roomName]];
    }
}
                    arity:-2
                    types:(int[]){ ArgTypeUsername, ArgTypeAny }], @"kick",
                 
// Buddy command
[Command commandWithType:[BuddyCommand class]], @"buddy",
                 
                 // end!
                 nil] retain];
    }
    return cmds;
}

- (NSArray *)completionsForIndex:(NSInteger)index
{
    return [NSArray array];
}

- (void)dealloc
{
    [command release];
    [types release];
    [super dealloc];
}

@end
