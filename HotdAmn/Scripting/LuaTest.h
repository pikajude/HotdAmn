//
//  LuaTest.h
//  HotdAmn
//
//  Created by Joel on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@interface LuaTest : NSObject {
    lua_State *L;
}

@property (readonly) NSMutableArray *items;

- (void)test;
- (void)printTest:(NSObject *)param;
- (void)initLua;
- (void)executeFile:(NSString *)filePath withIntepreterGlobalName:(NSString *)global error:(NSError **)err;

@end