//
//  ScriptList.h
//  HotdAmn
//
//  Created by Joel on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaErrLog.h"
#import "LuaInterop.h"

@interface ScriptList : NSWindowController {
    IBOutlet NSTextView *errList;
}

@end