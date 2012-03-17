//
//  LuaUtil.h
//  HotdAmn
//
//  Created by Joel on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lualib.h"
#import "lauxlib.h"

@interface LuaUtil : NSObject

+ (NSArray *)stringTableToArray:(lua_State *)L;
+ (NSArray *)argTableToArray:(lua_State *)L;
+ (void)pushArray:(lua_State *)L :(NSArray *)objects;

@end
