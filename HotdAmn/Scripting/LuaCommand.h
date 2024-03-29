//
//  LuaCommand.h
//  HotdAmn
//
//  Created by Joel on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POSIFY(arg) (arg < 0 ? -arg - 1 : arg)

enum {
    ArgAny = 1,
    ArgPrivclass = 1 << 1,
    ArgUsername = 1 << 2,
    ArgRoom = 1 << 3,
    ArgAll = ArgAny | ArgPrivclass | ArgUsername | ArgRoom,
};

@class LuaInterop;

@interface LuaCommand : NSObject {
    @private
    int regindex;
}

@property (readwrite) int arity;
@property (retain) NSArray *types;
@property (readonly) NSString *name;

- (id)initWithIndex:(int)index commandName:(NSString *)name;
- (void)executeWithArgs:(NSArray *)args;

+ (void)reset;
+ (BOOL)addCommand:(LuaCommand *)cmd;
+ (NSMutableDictionary *)commands;
+ (LuaCommand *)commandWithName:(NSString *)name;

@end