//
//  HDTabButtonCell.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HDTabButtonCell.h"

@implementation HDTabButtonCell

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

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	
}

- (NSRect)drawTitleAsDefault:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
	NSRange r = NSMakeRange(0, [title length]); // length of the whole string
	NSMutableAttributedString *str = [[title mutableCopy] autorelease];
	
	[str addAttribute:NSFontAttributeName
				value:[NSFont fontWithName:@"Helvetica-Bold" size:13.0f]
				range:r];

	[str addAttribute:NSForegroundColorAttributeName
				value:[NSColor colorWithDeviceWhite:0.43f alpha:1.0f]
				range:r];
		
		// 1px white shadow to look inset
	NSShadow *textshadow = [[[NSShadow alloc] init] autorelease];
	NSSize offset = NSMakeSize(0.0f, -1.0f);
	[textshadow setShadowOffset:offset];
	[textshadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.85f]];
	[str addAttribute:NSShadowAttributeName
				value:textshadow
				range:r];
	
	return [super drawTitle:str
				  withFrame:NSOffsetRect(frame, 0.0f, -1.0f) // move it up one pixel
					 inView:controlView];
}

- (NSRect)drawTitleAsHover:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
	NSRect rect = [controlView bounds];
	[NSGraphicsContext saveGraphicsState];
	
	NSGradient *bg = [[NSGradient alloc] initWithColorsAndLocations:
					  [NSColor colorWithDeviceWhite:0.83f alpha:1.0f], 0.0f,
					  [NSColor colorWithDeviceWhite:0.90f alpha:1.0f], 0.45f,
					  [NSColor colorWithDeviceWhite:0.95f alpha:1.0f], 1.0f, nil];
	[bg drawInRect:rect angle:270.0f];
	
	NSRect highlight = NSMakeRect(rect.origin.x,
								  rect.origin.y,
								  rect.size.width,
								  1.0f);
	
	[[NSColor whiteColor] set];
	NSRectFill(highlight);
	
	[bg release];
	
	NSRange r = NSMakeRange(0, [title length]); // length of the whole string
	NSMutableAttributedString *str = [[title mutableCopy] autorelease];
	
	[str addAttribute:NSFontAttributeName
				value:[NSFont fontWithName:@"Helvetica-Bold" size:13.0f]
				range:r];
	
	[str addAttribute:NSForegroundColorAttributeName
				value:[NSColor colorWithDeviceWhite:0.43f alpha:1.0f]
				range:r];
	
	// 1px white shadow to look inset
	NSShadow *textshadow = [[[NSShadow alloc] init] autorelease];
	NSSize offset = NSMakeSize(0.0f, -1.0f);
	[textshadow setShadowOffset:offset];
	[textshadow setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.85f]];
	[str addAttribute:NSShadowAttributeName
				value:textshadow
				range:r];
	
	return [super drawTitle:str
				  withFrame:NSOffsetRect(frame, 0.0f, -1.0f) // move it up one pixel
					 inView:controlView];
}


- (NSRect)drawTitleAsHighlighted:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
	NSRect rect = [controlView bounds];
	[NSGraphicsContext saveGraphicsState];
	
	NSGradient *bg = [[NSGradient alloc] initWithColorsAndLocations:
					  [NSColor colorWithDeviceWhite:0.48f alpha:1.0f], 0.0f,
					  [NSColor colorWithDeviceWhite:0.55f alpha:1.0f], 0.45f,
					  [NSColor colorWithDeviceWhite:0.60f alpha:1.0f], 1.0f, nil];
	[bg drawInRect:rect angle:270.0f];
	
	NSRect highlight = NSMakeRect(rect.origin.x,
								  rect.origin.y,
								  rect.size.width,
								  1.0f);
	
	[[NSColor colorWithDeviceWhite:0.75f alpha:1.0f] set];
	NSRectFill(highlight);
	
	[bg release];
	
	[NSGraphicsContext restoreGraphicsState];
	
	NSRange r = NSMakeRange(0, [title length]); // length of the whole string
	NSMutableAttributedString *str = [[title mutableCopy] autorelease];
	
	[str addAttribute:NSFontAttributeName
				value:[NSFont fontWithName:@"Helvetica-Bold" size:13.0f]
				range:r];
	
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
	
	return [super drawTitle:str
				  withFrame:NSOffsetRect(frame, 0.0f, -1.0f) // move it up one pixel
					 inView:controlView];
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
	switch ([self state]) {
		case NSOffState:
		default:
			return [self drawTitleAsDefault:title withFrame:frame inView:controlView];
			break;
			
		case NSOnState:
			return [self drawTitleAsHighlighted:title withFrame:frame inView:controlView];
			
		case NSMixedState:
			return [self drawTitleAsHover:title withFrame:frame inView:controlView];
	}
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

- (BOOL)showsBorderOnlyWhileMouseInside
{
	return YES;
}

- (NSInteger)highlightsBy
{
	return 1;
}

- (NSInteger)showsStateBy
{
	return 1;
}

@end
