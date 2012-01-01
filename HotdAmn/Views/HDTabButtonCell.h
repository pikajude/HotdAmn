//
//  HDTabButtonCell.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HDTabButtonCell : NSButtonCell

@property (assign) NSInteger prevState;

- (NSRect)drawTitleAsDefault:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView;
- (NSRect)drawTitleAsHighlighted:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView;
- (NSRect)drawTitleAsHover:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView;

@end
