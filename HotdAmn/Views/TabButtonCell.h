//
//  HDTabButtonCell.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TabButtonCell : NSButtonCell {
    NSInteger _badgeValue;
    NSImage *badge;
}

@property (assign) NSInteger prevState;

- (NSInteger)badgeValue;
- (void)setBadgeValue:(NSInteger)val;

@end
