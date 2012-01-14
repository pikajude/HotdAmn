//
//  HDTabButtonCell.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabButtonCell.h"

@implementation TabButtonCell

@synthesize prevState;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Drawing

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSRange r = NSMakeRange(0, [title length]); // length of the whole string
    NSMutableAttributedString *str = [[title mutableCopy] autorelease];
    [str addAttribute:NSFontAttributeName
                value:[NSFont fontWithName:@"Helvetica" size:13.0f]
                range:r];
    
    if ([self state] != NSOnState) {
        [str addAttribute:NSForegroundColorAttributeName
                    value:[NSColor whiteColor]
                    range:r];
        
        // 1px black shadow to pop
        NSShadow *textshadow = [[[NSShadow alloc] init] autorelease];
        NSSize offset = NSMakeSize(0.0f, -1.0f);
        [textshadow setShadowOffset:offset];
        [textshadow setShadowColor:[NSColor colorWithDeviceWhite:0.0f alpha:0.85f]];
        [str addAttribute:NSShadowAttributeName
                    value:textshadow
                    range:r];
    } else {
        [str addAttribute:NSForegroundColorAttributeName
                    value:[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]
                    range:r];
        
        // 1px white shadow to look inset
        NSShadow *textshadow = [[[NSShadow alloc] init] autorelease];
        NSSize offset = NSMakeSize(0.0f, -1.0f);
        [textshadow setShadowOffset:offset];
        [textshadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.85f]];
        [str addAttribute:NSShadowAttributeName
                    value:textshadow
                    range:r];
    }
    
    return [super drawTitle:str
                  withFrame:NSOffsetRect(frame, 0.0f, -1.0f) // move it up one pixel
                     inView:controlView];
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    [NSGraphicsContext saveGraphicsState];
    NSRect rect = [controlView bounds];
    
    if ([self state] == NSOnState) {
        [[NSColor whiteColor] set];
        
        NSRectFill(rect);
    } else if([self state] == NSMixedState) {
        [[NSColor colorWithDeviceWhite:1.0f alpha:0.25f] set];
        [NSBezierPath fillRect:frame];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    // Image is a dummy here; we're drawing the badge.
    [NSGraphicsContext saveGraphicsState];
    
    // Make some frame adjustments.
    NSRect newFrame = NSMakeRect(frame.origin.x,
                                 frame.origin.y + 3,
                                 frame.size.width,
                                 frame.size.height - 4);
    
    // The pill shape -- a rounded rectangle.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newFrame
                                                         xRadius:newFrame.size.height / 2
                                                         yRadius:newFrame.size.height / 2];
    
    // Pill background color.
    [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
    
    // Shadow for the pill.
    [path fill];
    
    [NSGraphicsContext restoreGraphicsState];
    
    [NSGraphicsContext saveGraphicsState];
    
    // Paragraph style for the title (centered).
    NSMutableParagraphStyle *pstyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [pstyle setAlignment:NSCenterTextAlignment];
    
    // The pill contents.
    NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", _badgeValue]] autorelease];
    
    // Pill attributes.
    [str addAttribute:NSForegroundColorAttributeName
                value:[NSColor colorWithDeviceWhite:0.28f alpha:1.0f]
                range:NSMakeRange(0, [str length])];
    [str addAttribute:NSFontAttributeName
                value:[NSFont fontWithName:@"Helvetica" size:11.0f]
                range:NSMakeRange(0, [str length])];
    [str addAttribute:NSParagraphStyleAttributeName
                value:pstyle
                range:NSMakeRange(0, [str length])];
    
    // Draw the title.
    [str drawInRect:newFrame];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (NSInteger)badgeValue
{
    return _badgeValue;
}

- (void)setBadgeValue:(NSInteger)bv
{
    if (bv == 0) {
        // Fix layout; cells with images are slightly wider,
        // even if the image is of size 0
        [self setImagePosition:NSNoImage];
        return [self setImage:nil];
    }
    if ([self state] == 1) {
        _badgeValue = 0;
        return;
    }
    _badgeValue = bv;
    [self setImagePosition:NSImageRight];
    NSImage *img = [[[NSImage alloc] init] autorelease];
    [img setSize:NSMakeSize(ceil(log10(bv))*5 + 20, [self cellSize].height)];
    [self setImage:img];
}

#pragma mark -
#pragma mark Event handling

- (void)mouseEntered:(NSEvent *)event
{
    if([self state] == NSOnState) return;
    [self setPrevState:[self state]];
    [self setState:NSMixedState];
}

- (void)mouseExited:(NSEvent *)event
{
    [self setState:[self prevState]];
}

- (NSInteger)showsStateBy
{
    return 1;
}

@end
