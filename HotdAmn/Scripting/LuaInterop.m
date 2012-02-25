//
//  LuaInterop.m
//  HotdAmn
//
//  Created by Joel on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaInterop.h"

static LuaInterop *globalRuntime;

@implementation LuaInterop

+ (LuaInterop *)lua {
    if (globalRuntime == nil) {
        globalRuntime = [[LuaInterop alloc] init];
    }
    return globalRuntime;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _L = lua_open();
    luaL_openlibs(_L);
    
    luaL_register(_L, "hotdamn", proxylibs);
    lua_getglobal(_L, "hotdamn");
    
    // regular attributes
    lua_pushstring(_L, "arg");
    lua_newtable(_L);
    
    // arg attributes
    lua_pushstring(_L, "any");
    lua_pushinteger(_L, ArgAny);
    lua_settable(_L, -3);
    
    lua_pushstring(_L, "username");
    lua_pushinteger(_L, ArgUsername);
    lua_settable(_L, -3);
    
    lua_pushstring(_L, "privclass");
    lua_pushinteger(_L, ArgPrivclass);
    lua_settable(_L, -3);
    
    lua_pushstring(_L, "room");
    lua_pushinteger(_L, ArgRoom);
    lua_settable(_L, -3);
    
    lua_pushstring(_L, "all");
    lua_pushinteger(_L, ArgAll);
    lua_settable(_L, -3);
    
    // add arg to hotdamn table
    lua_settable(_L, -3);
    
    lua_setglobal(_L, "hotdamn");
    
    return self;
}

- (void)execFile:(NSString *)filePath error:(NSError **)err
{
    const char *error = NULL;
    int loaded = luaL_loadfile(_L, [filePath UTF8String]);
    if(loaded == 0) {
        int ret = lua_pcall(_L, 0, 0, 0);
        if (ret != 0) {
            error = lua_tostring(_L, -1);
            lua_pop(_L, 1);
        }
    } else {
        error = lua_tostring(_L, -1);
        lua_pop(_L, 1);
    }
    
    if (error != NULL) {
        NSLog(@"%@", [NSString stringWithUTF8String:error]);
    }
}

- (void)executeRegistryFunction:(int)regIndex withObject:(NSArray *)obj
{
    lua_rawgeti(_L, LUA_REGISTRYINDEX, regIndex);
    [LuaUtil pushArray:_L :obj];
    int ret = lua_pcall(_L, 1, 0, 0);
    if (ret != 0) {
        NSLog(@"%s", lua_tostring(_L, -1));
        lua_pop(_L, -1);
    }
}

@end
