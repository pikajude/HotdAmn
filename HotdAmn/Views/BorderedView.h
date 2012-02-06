//
//  BorderedView.h
//  HotdAmn
//
//  Created by Joel on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BorderedView : NSView {
    NSColor *_borderColor;
    NSInteger _borderWidth;
}

- (void)setBorderColor:(NSColor *)borderColor;
- (NSColor *)borderColor;

- (void)setBorderWidth:(NSInteger)borderWidth;
- (NSInteger)borderWidth;

@end
