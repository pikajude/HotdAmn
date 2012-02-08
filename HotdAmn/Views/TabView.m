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
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSStringPboardType, NSTIFFPboardType, nil]];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [dragImage setParent:self];
    [dragImage setHidden:YES];
    [dragImage setFrameOrigin:[self frame].origin];
    [dragImage setFrameSize:NSMakeSize(0.0f, [self frame].size.height)];
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
    
    BOOL isKey = [[self window] isKeyWindow] || [[self window] isMainWindow];
    
    NSGradient *bg;
    if (isKey) {
        bg = [[NSGradient alloc] initWithColorsAndLocations:
              [NSColor colorWithDeviceWhite:0.48f alpha:1.0f], 0.0f,
              [NSColor colorWithDeviceWhite:0.55f alpha:1.0f], 0.45f,
              [NSColor colorWithDeviceWhite:0.60f alpha:1.0f], 0.75f,
              [NSColor colorWithDeviceWhite:0.55f alpha:1.0f], 1.0f, nil];
    } else {
        bg = [[NSGradient alloc] initWithColorsAndLocations:
              [NSColor colorWithDeviceWhite:0.64f alpha:1.0f], 0.0f,
              [NSColor colorWithDeviceWhite:0.71f alpha:1.0f], 0.45f,
              [NSColor colorWithDeviceWhite:0.76f alpha:1.0f], 0.75f,
              [NSColor colorWithDeviceWhite:0.71f alpha:1.0f], 1.0f, nil];
    }
    
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
    
    [[NSColor colorWithDeviceWhite:isKey ? 0.4f : 0.56f alpha:1.0f] set];
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
    [dragImage setImage:[[[NSImage alloc] initWithData:[[sender draggingPasteboard] dataForType:NSTIFFPboardType]] autorelease]];
    
    [dragImage setFrameSize:[[dragImage image] size]];
    
    [dragImage setFrameOrigin:NSMakePoint([sender draggingLocation].x - (TAB_WIDTH / 2), [dragImage frame].origin.y)];
    
    [dragImage setHidden:NO];
    
    [[self controller] hideButtonWithTitle:draggerName];
    return NSDragOperationMove;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    [self setNeedsDisplay:YES];
    NSInteger idx = [[self controller] indexOfRightmostButtonBeforePoint:[sender draggingLocation].x];
    NSInteger dragLoc = [sender draggingLocation].x;
    
    NSInteger rightLimit = [self frame].size.width - (TAB_WIDTH / 2);
    NSInteger leftLimit = SERVER_TAB_WIDTH + (TAB_WIDTH / 2);
    
    NSInteger destination = dragLoc > rightLimit ? rightLimit : dragLoc < leftLimit ? leftLimit : dragLoc;
    
    [dragImage setFrameOrigin:NSMakePoint(destination - (TAB_WIDTH / 2), [dragImage frame].origin.y)];
    
    if (dragIndex != idx) {
        [[self controller] insertButton:dragger atIndex:idx fromIndex:dragIndex];
        dragIndex = idx;
    }
    return NSDragOperationMove;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    [NSAnimationContext beginGrouping];
    
    [[NSAnimationContext currentContext] setDuration:0.25];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[NSAnimationContext currentContext] setCompletionHandler:^(void) {
        [dragImage setImage:nil];
        [dragImage setHidden:YES];
        [[self controller] insertButton:dragger atIndex:dragIndex fromIndex:dragIndex];
        [[self controller] showButtonWithTitle:[dragger title]];
        [[dragger cell] setBadgeValue:0];
        [[self controller] resizeButtons];
    }];
    
    NSPoint destination = NSMakePoint((dragIndex - 1)*160 + 80, [[[self window] contentView] frame].size.height - 24.0f);
    [[dragImage animator] setFrameOrigin:destination];
    
    [NSAnimationContext endGrouping];
}

- (void)willRemoveSubview:(NSView *)subview
{
    [[[self controller] tabs] removeObjectForKey:[(TabButton *)subview roomName]];
}

- (void)dealloc
{
    [dragImage release];
    [super dealloc];
}

@end
