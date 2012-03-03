//
//  ScriptErrorView.m
//  HotdAmn
//
//  Created by Joel on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScriptErrorView.h"

@implementation ScriptErrorView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor yellowColor] set];
    NSRectFill(dirtyRect);
}

@end
