//
//  HDTabButton.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import "TabBar.h"
#import "TabButtonCell.h"
#import "Chat.h"

@interface TabButton : NSButton

@property (assign) NSViewController *chatView;
@property (assign) id ctrl;

- (void)select;
- (void)deselect;
- (void)addTracker;
- (void)createChatView;

@end