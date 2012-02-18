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
        for (int i = 0; i < POSIFY(ar); i++) {
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
[Command commandWithBlock:^(Command *me, Chat *caller, id<ChatDelegate>receiver, NSArray *args)
{
    if ([args count] == 0) {
        if ([User listForRoom:[[caller delegate] roomName]] != nil) {
            [caller error:@"You're already joined."];
        } else {
            [receiver join:[[caller delegate] roomName]];
        }
        return;
    }
    
    for (NSString *room in args) {
        [receiver join:room];
    }
}
                    arity:-1
                    types:(int[]){ ArgTypeAny }], @"join",
                 
// Part command
[Command commandWithBlock:^(Command *me, Chat *caller, id<ChatDelegate> receiver, NSArray *args) {
    if ([args count] == 0) {
        [receiver part:[caller roomName]];
        return;
    }
    for (NSString *room in args) {
        [receiver part:room];
    }
}
                    arity:-1
                    types:(int[]){ ArgTypeRoom }], @"part",
                 
// Action command
[Command commandWithBlock:^(Command *me, Chat *caller, id<ChatDelegate>receiver, NSArray *args)
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
[Command commandWithBlock:^(Command *me, Chat *caller, id<ChatDelegate>receiver, NSArray *args)
{
    NSError *err = nil;
    if (![me verifyArity:args error:&err]) {
        [caller error:[err localizedDescription]];
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

[Command commandWithBlock:^(Command *me, Chat *caller, id<ChatDelegate>receiver, NSArray *args) {
    NSError *err = nil;
    if (![me verifyArity:args error:&err]) {
        [caller error:[err localizedDescription]];
        return;
    }
    [receiver join:[UserManager formatChatroom:[args objectAtIndex:0]]];
}
                    arity:1
                    types:(int[]){ ArgTypeUsername }], @"chat",
                 
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

static NSError *createError(NSString *msg, NSInteger code) {
    return [NSError errorWithDomain:@"org.jdt.commands"
                               code:code
                           userInfo:[NSDictionary dictionaryWithObject:msg
                                                                forKey:NSLocalizedDescriptionKey]];
}

- (BOOL)verifyArity:(NSArray *)args error:(NSError **)err
{
    NSInteger cnt = [args count];
    NSInteger ar = [self arity];
    NSString *errmsg = @"Wrong number of arguments (got %ld, expected %ld).";
    if (ar >= 0) {
        if (cnt == ar)
            return true;
    } else {
        if (cnt >= -ar - 1)
            return true;
    }
    if (*err != NULL)
        *err = createError([NSString stringWithFormat:errmsg, cnt, POSIFY(ar)], -1);
    return false;
}

- (void)dealloc
{
    [command release];
    [types release];
    [super dealloc];
}

@end
