//
//  ScriptErrorSingle.h
//  HotdAmn
//
//  Created by Joel on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaErrLog.h"

@interface ScriptErrorSingle : NSViewController {
    IBOutlet NSTextField *filename;
    IBOutlet NSTextField *errDesc;
}

- (void)setLog:(LuaErrLog *)l;

@end
