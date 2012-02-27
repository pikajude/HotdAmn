//
//  LuaHotDamn.m
//  HotdAmn
//
//  Created by Joel on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaHotDamn.h"
#import "HotDamn.h"

static int hd_registerCmd(lua_State *L) {
    int args = lua_gettop(L);
    switch (args) {
        case 2: {
            const char *name = luaL_checkstring(L, 1);
            luaL_checktype(L, 2, LUA_TFUNCTION);
            int ref = luaL_ref(L, LUA_REGISTRYINDEX);
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:STR(name)] autorelease];
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
            LuaCommand *c = [[[LuaCommand alloc] initWithIndex:ref commandName:STR(name)] autorelease];
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

static int hd_join(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    [[HOTDAMN evtHandler] join:STR(room)];
    return 0;
}

static int hd_part(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    [[HOTDAMN evtHandler] part:STR(room)];
    return 0;
}

static int hd_say(lua_State *L) {
    const char *roomname = luaL_checkstring(L, 1);
    const char *toSay = luaL_checkstring(L, 2);
    bool parsed = true;
    if (lua_gettop(L) >= 3) {
        luaL_checktype(L, 3, LUA_TBOOLEAN);
        parsed = lua_toboolean(L, 3);
    }
    if (parsed)
        [[HOTDAMN evtHandler] say:STR(toSay)
                           inRoom:STR(roomname)];
    else
        [[HOTDAMN evtHandler] sayUnparsed:STR(toSay)
                                   inRoom:STR(roomname)];
        
    return 0;
}

static int hd_action(lua_State *L) {
    [[HOTDAMN evtHandler] action:STR(luaL_checkstring(L, 2))
                          inRoom:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_kick(lua_State *L) {
    const char *roomname = luaL_checkstring(L, 1);
    const char *username = luaL_checkstring(L, 2);
    if (lua_gettop(L) > 2) {
        [[HOTDAMN evtHandler] kick:STR(username)
                          fromRoom:STR(roomname)
                        withReason:STR(luaL_checkstring(L, 3))];
    } else {
        [[HOTDAMN evtHandler] kick:STR(username)
                          fromRoom:STR(roomname)];
    }
    return 0;
}

static int hd_ban(lua_State *L) {
    [[HOTDAMN evtHandler] ban:STR(luaL_checkstring(L, 2))
                     fromRoom:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_unban(lua_State *L) {
    [[HOTDAMN evtHandler] unban:STR(luaL_checkstring(L, 2))
                       fromRoom:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_whois(lua_State *L) {
    [[HOTDAMN evtHandler] whois:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_promote(lua_State *L) {
    if (lua_gettop(L) > 2) {
        [[HOTDAMN evtHandler] promote:STR(luaL_checkstring(L, 2))
                          toPrivclass:STR(luaL_checkstring(L, 3))
                               inRoom:STR(luaL_checkstring(L, 1))];
    } else {
        [[HOTDAMN evtHandler] promote:STR(luaL_checkstring(L, 2))
                               inRoom:STR(luaL_checkstring(L, 1))];
    }
    return 0;
}

static int hd_getTopic(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    NSString *top = [Topic topicForRoom:STR(room)];
    if (top == nil)
        luaL_error(L, "not joined to %s", room);
    lua_pushstring(L, [top UTF8String]);
    return 1;
}

static int hd_setTopic(lua_State *L) {
    [[HOTDAMN evtHandler] setTopic:STR(luaL_checkstring(L, 2))
                            inRoom:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_getTitle(lua_State *L) {
    const char *room = luaL_checkstring(L, 1);
    NSString *top = [Topic titleForRoom:STR(room)];
    if (top == nil)
        luaL_error(L, "not joined to %s", room);
    lua_pushstring(L, [top UTF8String]);
    return 1;
}

static int hd_setTitle(lua_State *L) {
    [[HOTDAMN evtHandler] setTitle:STR(luaL_checkstring(L, 2))
                            inRoom:STR(luaL_checkstring(L, 1))];
    return 0;
}

static int hd_currentRoom(lua_State *L) {
    lua_pushstring(L, [[[[HOTDAMN barControl] highlightedTab] roomName] UTF8String]);
    return 1;
}

static int hd_print(lua_State *L) {
    Message *m = [[[Message alloc] initWithContent:STR(luaL_checkstring(L, 2))] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"message-%@", STR(luaL_checkstring(L, 1))]
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:m
                                                                                           forKey:@"msg"]];
    return 0;
}

const struct luaL_Reg proxylibs[18] = {
    {"register_cmd", hd_registerCmd},
    {"say", hd_say},
    {"action", hd_action},
    {"join", hd_join},
    {"part", hd_part},
    {"kick", hd_kick},
    {"ban", hd_ban},
    {"unban", hd_unban},
    {"whois", hd_whois},
    {"promote", hd_promote},
    {"demote", hd_promote},
    
    {"current_room", hd_currentRoom},
    {"gettopic", hd_getTopic},
    {"settopic", hd_setTopic},
    {"gettitle", hd_getTitle},
    {"settitle", hd_setTitle},
    
    {"print", hd_print},
    {NULL, NULL}
};
