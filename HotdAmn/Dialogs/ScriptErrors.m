//
//  ScriptErrors.m
//  HotdAmn
//
//  Created by Joel on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScriptErrors.h"

@implementation ScriptErrors

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[LuaErrLog log] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ScriptErrorSingle *s = [[[ScriptErrorSingle alloc] initWithNibName:@"ScriptErrorSingle"
                                                                bundle:[NSBundle mainBundle]] autorelease];
    [s view];
    [s setLog:[[LuaErrLog log] objectAtIndex:row]];
    return [s view];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 60.0f;
}

@end
