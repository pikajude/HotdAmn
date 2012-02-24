//
//  LuaUtil.m
//  HotdAmn
//
//  Created by Joel on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaUtil.h"

@implementation LuaUtil

+ (NSArray *)argTableToArray:(lua_State *)L
{
    NSMutableArray *ar = [NSMutableArray array];
    size_t len = lua_objlen(L, -1);
    for (int i = 1; i <= len; i++) {
        lua_pushinteger(L, i);
        lua_gettable(L, -2);
        if (lua_istable(L, -1)) {
            [ar addObject:[self stringTableToArray:L]];
        } else if(lua_isnumber(L, -1)) {
            [ar addObject:[NSNumber numberWithInt:lua_tonumber(L, -1)]];
        } else
            luaL_error(L, "invalid type in list: expected table or int, found %s", luaL_typename(L, -1));
        lua_pop(L, 1);
    }
    return (NSArray *)ar;
}

+ (NSArray *)stringTableToArray:(lua_State *)L
{
    NSMutableArray *ar = [NSMutableArray array];
    size_t len = lua_objlen(L, -1);
    for (int i = 1; i <= len; i++) {
        lua_pushinteger(L, i);
        lua_gettable(L, -2);
        if (lua_type(L, -1) == LUA_TSTRING) {
            [ar addObject:[NSString stringWithUTF8String:luaL_checkstring(L, -1)]];
        } else
            luaL_error(L, "invalid type in list: expected string, found %s", luaL_typename(L, -1));
        lua_pop(L, 1);
    }
    return (NSArray *)ar;
}

+ (void)pushArray:(lua_State *)L :(NSArray *)objects
{
    lua_newtable(L);
    for (int i = 0; i < [objects count]; i++) {
        lua_pushnumber(L, i + 1);
        lua_pushstring(L, [[objects objectAtIndex:i] UTF8String]);
        lua_settable(L, -3);
    }
}

@end