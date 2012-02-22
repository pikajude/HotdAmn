//
//  LuaInterop.m
//  HotdAmn
//
//  Created by Joel on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaInterop.h"
#import "HDProxy.h"

static NSArray *stringtable_to_ary(lua_State *L) {
    NSMutableArray *ar = [NSMutableArray array];
    size_t len = lua_objlen(L, -1);
    for (int i = 1; i <= len; i++) {
        lua_pushinteger(L, i);
        lua_gettable(L, -2);
        if (lua_type(L, -1) == LUA_TSTRING) {
            [ar addObject:[NSString stringWithUTF8String:luaL_checkstring(L, -1)]];
        } else {
            char str[80];
            sprintf(str, "invalid type in argtype option list: expected string, found %s", luaL_typename(L, -1));
            lua_pushstring(L, str);
            lua_error(L);
        }
        lua_pop(L, 1);
    }
    return (NSArray *)ar;
}

static NSArray *argtable_to_ary(lua_State *L) {
    NSMutableArray *ar = [NSMutableArray array];
    size_t len = lua_objlen(L, -1);
    for (int i = 1; i <= len; i++) {
        lua_pushinteger(L, i);
        lua_gettable(L, -2);
        if (lua_istable(L, -1)) {
            [ar addObject:stringtable_to_ary(L)];
        } else if(lua_isnumber(L, -1)) {
            [ar addObject:[NSNumber numberWithInt:lua_tonumber(L, -1)]];
        } else {
            char str[80];
            sprintf(str, "invalid type in argtype list: expected table or int, found %s", luaL_typename(L, -1));
            lua_pushstring(L, str);
            lua_error(L);
        }
        lua_pop(L, 1);
    }
    return (NSArray *)ar;
}

static int register_cmd(lua_State *L) {
    int args = lua_gettop(L);
    switch (args) {
        case 3: {
            const char *name = luaL_checkstring(L, 2);
            luaL_checktype(L, 3, LUA_TFUNCTION);
            int ref = luaL_ref(L, LUA_REGISTRYINDEX);
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:[NSString stringWithUTF8String:name]] autorelease];
            [LuaCommand addCommand:c];
        }
            break;
            
        case 5: {
            const char *name = luaL_checkstring(L, 2);
            luaL_checktype(L, 3, LUA_TFUNCTION);
            lua_pushvalue(L, 3);
            int ref = luaL_ref(L, LUA_REGISTRYINDEX);
            int arity = luaL_checkint(L, 4);
            luaL_checktype(L, 5, LUA_TTABLE);
            NSArray *types = argtable_to_ary(L);
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:[NSString stringWithUTF8String:name]] autorelease];
            [c setArity:arity];
            [c setTypes:types];
            [LuaCommand addCommand:c];
        }
            break;
            
        default:
            lua_pushstring(L, "wrong number of arguments to register_cmd: expected 2 or 4");
            lua_error(L);
            break;
    }
    return 0;
}

static const struct luaL_Reg proxylibs[] = {
    {"register_cmd", register_cmd},
    {NULL, NULL}
};

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
    
    // create hotdamn global
    luaL_newmetatable(_L, "hotdamn");
    luaL_register(_L, NULL, proxylibs);
    
    // meta-attributes
    lua_pushstring(_L, "__index");
    lua_pushvalue(_L, -2);
    lua_settable(_L, -3); 
    
    lua_newtable(_L);
    luaL_getmetatable(_L, "hotdamn");
    lua_setmetatable(_L, -2);
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
    luaL_loadfile(_L, [filePath UTF8String]);
    int ret = lua_pcall(_L, 0, 0, 0);
    if (ret != 0) {
        NSLog(@"%@", [NSString stringWithUTF8String:lua_tostring(_L, -1)]);
        lua_pop(_L, 1);
    }
}

@end
