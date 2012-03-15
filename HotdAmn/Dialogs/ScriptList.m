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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onError:)
                                                 name:@"luaerr"
                                               object:nil];
    
    return self;
}

- (void)awakeFromNib
{
    [errList setString:[NSString stringWithFormat:@"%@\n", [[LuaErrLog log] componentsJoinedByString:@"\n"]]];
    [[errList textStorage] setFont:[NSFont fontWithName:@"Menlo" size:11.0f]];
}

- (void)clearLog:(id)sender
{
    [errList setString:@""];
}

- (void)onError:(NSNotification *)err
{
    [errList setString:[[errList string] stringByAppendingString:[NSString stringWithFormat:@"%@\n", [[err userInfo] objectForKey:@"err"]]]];
}

@end
