//
//  ChatView.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatView.h"

@implementation ChatView

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
    NSRect shrunkenRect = NSMakeRect(dirtyRect.origin.x + 7,
                                     dirtyRect.origin.y + 8,
                                     dirtyRect.size.width - 14,
                                     dirtyRect.size.height - 16);
    [[NSColor colorWithDeviceWhite:0.67f alpha:1.0f] set];
    NSFrameRectWithWidth(shrunkenRect, 1.0f);
    [super drawRect:dirtyRect];
}

@end
