//
//  LuaHotDamn.m
//  HotdAmn
//
//  Created by Joel on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaHotDamn.h"
#import "HotDamn.h"

int hd_registerCmd(lua_State *L) {
    int args = lua_gettop(L);
    switch (args) {
        case 2: {
            const char *name = luaL_checkstring(L, 1);
            luaL_checktype(L, 2, LUA_TFUNCTION);
            int ref = luaL_ref(L, LUA_REGISTRYINDEX);
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:[NSString stringWithUTF8String:name]] autorelease];
            [c setArity:0];
            if(![LuaCommand addCommand:c])
                luaL_error(L, "command '%s' already exists", name);
        }
            break;
            
        case 4: {
            const char *name = luaL_checkstring(L, 1);
            luaL_checktype(L, 2, LUA_TFUNCTION);
            lua_pushvalue(L, 2);
            int ref = luaL_ref(L, LUA_REGISTRYINDEX);
            int arity = luaL_checkint(L, 3);
            luaL_checktype(L, 4, LUA_TTABLE);
            NSArray *types = [LuaUtil argTableToArray:L];
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:[NSString stringWithUTF8String:name]] autorelease];
            [c setArity:arity];
            [c setTypes:types];
            if(![LuaCommand addCommand:c])
                luaL_error(L, "command '%s' already exists", name);
        }
            break;
            
        default:
            luaL_error(L, "wrong number of arguments to register_cmd: got %d, expected 2 or 4", args);
            break;
    }
    return 0;
}

int hd_join(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    [[HOTDAMN evtHandler] join:[NSString stringWithUTF8String:room]];
    return 0;
}

int hd_part(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    [[HOTDAMN evtHandler] part:[NSString stringWithUTF8String:room]];
    return 0;
}

int hd_say(lua_State *L) {
    int argc = lua_gettop(L);
    NSString *tabName;
    NSString *toSay;
    if (argc == 1) {
        tabName = [[[HOTDAMN barControl] highlightedTab] roomName];
        toSay = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
    } else {
        tabName = [NSString stringWithUTF8String:luaL_checkstring(L, 1)];
        toSay = [NSString stringWithUTF8String:luaL_checkstring(L, 2)];
    }
    [[HOTDAMN evtHandler] say:toSay inRoom:tabName];
    return 0;
}

int hd_currentRoom(lua_State *L) {
    lua_pushstring(L, [[[[HOTDAMN barControl] highlightedTab] roomName] UTF8String]);
    return 1;
}

const struct luaL_Reg proxylibs[6] = {
    {"register_cmd", hd_registerCmd},
    {"say", hd_say},
    {"join", hd_join},
    {"part", hd_part},
    {"current_room", hd_currentRoom},
    {NULL, NULL}
};

@implementation LuaHotDamn

@end
