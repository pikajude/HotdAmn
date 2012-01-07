//
//  HDTabButton.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabButton.h"

@implementation TabButton

@synthesize ctrl;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)select
{
    [[self cell] setState:1];
    [[self cell] setPrevState:1];
}

- (void)deselect
{
    [[self cell] setState:0];
    [[self cell] setPrevState:0];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [[self cell] mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[self cell] mouseExited:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self setState:1];
    [[self target] performSelector:[self action] withObject:self];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [[self cell] setBadgeValue:0];
    [[self ctrl] resizeButtons];
}

- (void)resetCursorRects
{
    NSCursor *c = [NSCursor pointingHandCursor];
    [self addCursorRect:[self bounds] cursor:c];
    [c setOnMouseEntered:YES];
    [super resetCursorRects];
}

- (void)setState:(NSInteger)value
{
    [[self cell] setPrevState:value];
    [super setState:value];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    return NSDragOperationMove;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if ([[self title] isEqualToString:@"Server"]) return;
    NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [rep setSize:[self bounds].size];
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:rep];
    NSImage *img = [[[NSImage alloc] initWithSize:NSZeroSize] autorelease];
    [img addRepresentation:rep];
    NSSize offset = NSMakeSize(0.0f, 0.0f);
    NSPoint point = NSMakePoint(0.0f, 30.0f);
    
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    [pboard setData:[[self title] dataUsingEncoding:NSUTF8StringEncoding] forType:NSStringPboardType];
    
    [self dragImage:img
                 at:point
             offset:offset
              event:theEvent
         pasteboard:pboard
             source:self
          slideBack:NO];
}

- (void)addTracker
{
    NSTrackingArea *ar = [[[NSTrackingArea alloc]
                          initWithRect:[self bounds]
                               options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow
                                 owner:self
                              userInfo:nil] autorelease];
    [self addTrackingArea:ar];
}

@end