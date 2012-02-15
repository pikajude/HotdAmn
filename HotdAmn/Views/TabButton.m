//
//  HDTabButton.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabButton.h"
#import "TabBar.h"

@implementation TabButton

@synthesize ctrl, chatRoom;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)createChatView
{
    if ([[self title] isEqualToString:@"Server"]) {
        chatRoom = [[ServerChat alloc] initWithNibName:nil bundle:[NSBundle mainBundle] roomName:@"Server"];
    } else {
        chatRoom = [[Chat alloc] initWithNibName:@"ChatView" bundle:[NSBundle mainBundle] roomName:[self title]];
    }
    NSRect frame = [[[self window] contentView] frame];
    NSRect ourframe = NSMakeRect(frame.origin.x,
                                 frame.origin.y,
                                 frame.size.width,
                                 frame.size.height - 24);
    [chatRoom setDelegate:self];
    [[chatRoom view] setHidden:YES];
    [[[self window] contentView] addSubview:[chatRoom view]];
    [[chatRoom view] setFrame:ourframe];
    [[chatRoom split] setDelegate:chatRoom];
    [[chatRoom view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
}

- (void)select
{
    [[self cell] setState:1];
    [[self cell] setPrevState:1];
    [[chatRoom view] setHidden:NO];
    [chatRoom selectInput];
    [self mouseUp:nil];
}

- (void)deselect
{
    [[self cell] setState:0];
    [[self cell] setPrevState:0];
    [[chatRoom view] setHidden:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [[self cell] mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[self cell] mouseExited:theEvent];
    [[self superview] setNeedsDisplayInRect:[self bounds]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self setState:1];
    [[self target] performSelector:[self action] withObject:self];
    [[self superview] setNeedsDisplay:YES];
    [chatRoom onTopicChange];
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
    [pboard setData:[img TIFFRepresentation] forType:NSTIFFPboardType];
    
    [self dragImage:nil
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

- (CGFloat)dividerPos
{
    if ([[self title] isEqualToString:@"Server"])
        return 0.0f;
    NSView *v = [chatRoom chatContainer];
    return [v frame].size.width + [v frame].origin.x;
}

- (void)setDividerPos:(CGFloat)pos
{
    if ([[self title] isEqualToString:@"Server"])
        return;
    [[chatRoom split] setPosition:pos ofDividerAtIndex:0];
}

- (NSString *)roomName
{
    return [[self title] stringByReplacingOccurrencesOfString:@"#" withString:@""];
}

- (void)addLine:(Message *)str
{
    [chatRoom addLine:str];
}

- (void)dealloc
{
    [[chatRoom view] removeFromSuperview];
    [chatRoom release];
    [super dealloc];
}

@end