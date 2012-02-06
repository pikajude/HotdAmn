//
//  Command.h
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define POSIFY(arg) (arg < 0 ? -arg - 1 : arg)

#import <Foundation/Foundation.h>
#import "Chat.h"

/*
 Algorithm for commands is pretty complicated.
 Greediness specifies whether the command wants all of the arguments
 passed to it. For 0-arity commands, this parameter doesn't really matter.I
 Otherwise, if the arity is nonzero, and greedy is set to yes, the
 selector will be called once for each argument. The command will also
 tab-complete match indefinitely for that type of argument.
 */

enum {
    ArgTypeAny = 1,
    ArgTypePrivclass = 1 << 1,
    ArgTypeUsername = 1 << 2,
    ArgTypeRoom = 1 << 3,
    ArgTypeAll = ArgTypeAny | ArgTypePrivclass | ArgTypeUsername | ArgTypeRoom,
    
    ArgTypeCustom = -1
};

@protocol ChatDelegate <NSObject>

- (void)join:(NSString *)room;
- (void)part:(NSString *)room;
- (void)say:(NSString *)str inRoom:(NSString *)room;
- (void)sayUnparsed:(NSString *)str inRoom:(NSString *)room;
- (void)action:(NSString *)str inRoom:(NSString *)room;
- (void)kick:(NSString *)user fromRoom:(NSString *)room;
- (void)kick:(NSString *)user fromRoom:(NSString *)room withReason:(NSString *)reason;
- (void)setTopic:(NSString *)topic inRoom:(NSString *)room;

@end

@class Chat;

@class BuddyCommand;

@class Command;
typedef void (^commandBlock)(Command *me, Chat *caller, id<ChatDelegate> receiver, NSArray *args);

@interface Command : NSObject

@property (retain) commandBlock command;
@property (readwrite) NSInteger arity;
@property (retain) NSArray *types;

// For use in subclasses.
- (NSArray *)completionsForIndex:(NSInteger)index;

- (BOOL)verifyArity:(NSArray *)args error:(NSError **)err;

+ (Command *)commandWithBlock:(commandBlock)block arity:(NSInteger)ar types:(int[])types;
+ (Command *)commandWithType:(Class)type;

+ (NSDictionary *)allCommands;

@end
