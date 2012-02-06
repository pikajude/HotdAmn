//
//  BorderedView.m
//  HotdAmn
//
//  Created by Joel on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BorderedView.h"

@implementation BorderedView

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
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *rect = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_borderColor)
        [_borderColor set];
    [rect stroke];
    
    [NSGraphicsContext restoreGraphicsState];
    
    [super drawRect:dirtyRect];
}

- (void)setBorderColor:(NSColor *)borderColor
{
    _borderColor = [borderColor retain];
    [self setNeedsDisplay:YES];
}

- (NSColor *)borderColor
{
    return _borderColor;
}

- (void)setBorderWidth:(NSInteger)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay:YES];
}

- (NSInteger)borderWidth
{
    return _borderWidth;
}

- (void)dealloc
{
    [_borderColor release];
    [super dealloc];
}

@end
