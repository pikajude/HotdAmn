//
//  ScriptList.m
//  HotdAmn
//
//  Created by Joel on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScriptList.h"

@implementation ScriptList

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [errList setString:[[LuaErrLog log] componentsJoinedByString:@"\n"]];
    [[errList textStorage] setFont:[NSFont fontWithName:@"Menlo" size:11.0f]];
}

@end
