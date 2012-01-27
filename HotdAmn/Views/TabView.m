//
//  HDTabBarView.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabView.h"
#import "TabBar.h"

@implementation TabView

@synthesize controller;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
    }
    
    return self;
}

- (NSInteger)contentWidth
{
    NSInteger i = 0;
    for(NSButton *button in [self subviews]) {
        i += [[button cell] cellSize].width + 8;
    }
    return i;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [NSGraphicsContext saveGraphicsState];
    
    NSGradient *bg = [[NSGradient alloc] initWithColorsAndLocations:
                      [NSColor colorWithDeviceWhite:0.48f alpha:1.0f], 0.0f,
                      [NSColor colorWithDeviceWhite:0.55f alpha:1.0f], 0.45f,
                      [NSColor colorWithDeviceWhite:0.60f alpha:1.0f], 0.75f,
                      [NSColor colorWithDeviceWhite:0.55f alpha:1.0f], 1.0f, nil];
    
    [bg drawInRect:dirtyRect angle:90.0f];
    [bg release];
    
    NSRect highlight = NSMakeRect(0.0f,
                                  dirtyRect.origin.y + dirtyRect.size.height - 1,
                                  dirtyRect.size.width,
                                  1.0f);
    
    NSRect lowlight = NSMakeRect(0.0f,
                                 dirtyRect.origin.y, 
                                 dirtyRect.size.width,
                                 1.0f);
    
    [[NSColor colorWithDeviceWhite:0.4f alpha:1.0f] set];
    NSRectFill(highlight);
    NSRectFill(lowlight);
        
    [NSGraphicsContext restoreGraphicsState];
}

#pragma mark -
#pragma mark Drag-n-Drop

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSString *draggerName = [[[NSString alloc] initWithData:[[sender draggingPasteboard] dataForType:NSStringPboardType] encoding:NSUTF8StringEncoding] autorelease];
    dragger = [[self controller] getButtonWithTitle:draggerName];
    [[self controller] hideButtonWithTitle:draggerName];
    return NSDragOperationMove;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSInteger idx = [[self controller] indexOfRightmostButtonBeforePoint:[sender draggingLocation].x];
    if (dragIndex != idx) {
        dragIndex = idx;
        // Move a spacer to the new spot.
        [[self controller] insertButton:dragger atIndex:dragIndex];
    }
    return NSDragOperationMove;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    [[self controller] insertButton:dragger atIndex:dragIndex];
    [[self controller] showButtonWithTitle:[dragger title]];
    [[dragger cell] setBadgeValue:0];
    [[self controller] resizeButtons];
}

- (void)willRemoveSubview:(NSView *)subview
{
    [[[self controller] tabs] removeObjectForKey:[(TabButton *)subview roomName]];
}

@end
