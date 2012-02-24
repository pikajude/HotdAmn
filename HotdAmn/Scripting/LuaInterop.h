//
//  LuaInterop.h
//  HotdAmn
//
//  Created by Joel on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCommand.h"
#import "LuaHotDamn.h"

@interface LuaInterop : NSObject {
    lua_State *_L;
}

+ (LuaInterop *)lua;

- (void)execFile:(NSString *)filePath error:(NSError **)err;
- (void)executeRegistryFunction:(int)regIndex withObject:(NSArray *)obj;

@end
