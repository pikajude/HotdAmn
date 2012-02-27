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
#import "Topic.h"
#import "Message.h"

#define HOTDAMN ((id)[[NSApplication sharedApplication] delegate])
#define STR(x) [NSString stringWithUTF8String:(x)]

const struct luaL_Reg proxylibs[18];