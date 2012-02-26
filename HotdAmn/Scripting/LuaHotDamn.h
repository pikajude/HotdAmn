//
//  LuaHotDamn.h
//  HotdAmn
//
//  Created by Joel on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaUtil.h"
#import "LuaCommand.h"

#define HOTDAMN ((id)[[NSApplication sharedApplication] delegate])
#define STR(x) [NSString stringWithUTF8String:(x)]

static int hd_registerCmd(lua_State *L);
static int hd_join(lua_State *L);
static int hd_part(lua_State *L);
static int hd_say(lua_State *L);
static int hd_action(lua_State *L);
static int hd_kick(lua_State *L);

static int hd_currentRoom(lua_State *L);

const struct luaL_Reg proxylibs[8];

@interface LuaHotDamn : NSObject

@end