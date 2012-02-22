//
//  LuaTest.m
//  HotdAmn
//
//  Created by Joel on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaTest.h"

static NSMutableArray *tableToArray(lua_State *L) {
    NSMutableArray *ar = [NSMutableArray array];
    size_t size = lua_objlen(L, 2);
    for (int i = 1; i <= size; i++) {
        lua_pushnumber(L, i);
        lua_gettable(L, 2);
        [ar addObject:[NSNumber numberWithInt:lua_tonumber(L, -1)]];
        lua_pop(L, 1);
    }
    return ar;
}

static int hookhd(lua_State *L) {
    luaL_checktype(L, 2, LUA_TTABLE);
    NSMutableArray *objs = tableToArray(L);
    NSLog(@"%@", objs);
    return 0;
}

static const struct luaL_Reg arraylibs_m[] = {
    {"hook", hookhd},
    {NULL, NULL}
};

@implementation LuaTest

@synthesize items;

- (id)init
{
    self = [super init];
    L = lua_open();
    items = [[NSMutableArray array] retain];
    return self;
}

- (void)initLua
{
    luaL_newmetatable(L, "hotdamn");
    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);
    lua_settable(L, -3);
    
    void **userdata = lua_newuserdata(L, sizeof(self));
    luaL_getmetatable(L, "hotdamn");
    lua_setmetatable(L, -2);
    *userdata = self;
}

- (void)executeFile:(NSString *)filePath withIntepreterGlobalName:(NSString *)global error:(NSError **)err
{
    lua_setglobal(L, [global UTF8String]);
    luaL_openlib(L, NULL, arraylibs_m, 0);
    luaL_loadfile(L, [filePath UTF8String]);
    int ret = lua_pcall(L, 0, 0, 0);
    if (ret != 0) {
        NSString *er = [NSString stringWithUTF8String:lua_tostring(L, -1)];
        *err = [[[NSError alloc] initWithDomain:@"org.jdt.lua"
                                           code:ret
                                       userInfo:[NSDictionary dictionaryWithObject:er
                                                              forKey:NSLocalizedDescriptionKey]] 
                autorelease];
    }
    lua_pop(L, 1); // remove loaded file
}

- (void)test
{
    [self initLua];
    NSError *error;
    [self executeFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"lua"]
withIntepreterGlobalName:@"obj"
                error:&error];
}

- (void)printTest:(NSString *)param
{
    NSLog(@"%@", param);
}

- (void)dealloc
{
    lua_close(L);
    [items release];
    [super dealloc];
}

@end
