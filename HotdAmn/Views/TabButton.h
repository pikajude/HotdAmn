//
//  HDTabButton.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "TabBar.h"
#import "TabButtonCell.h"

@interface TabButton : NSButton

@property (assign) id ctrl;

- (void)select;
- (void)deselect;
- (void)addTracker;

@end