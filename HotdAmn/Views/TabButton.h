//
//  HDTabButton.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define TAB_HEIGHT 24.0f

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import "TabButtonCell.h"
#import "Chat.h"
#import "ServerChat.h"
#import "Message.h"

@class TabBar;

@interface TabButton : NSButton <NSSplitViewDelegate> {
    BOOL _joined;
}

@property (retain) Chat *chatRoom;
@property (retain) NSString *roomName;
@property (assign) id ctrl;
@property (assign) BOOL isPchat;

- (void)select;
- (void)deselect;
- (void)addTracker;
- (void)createChatView;

- (CGFloat)dividerPos;
- (void)setDividerPos:(CGFloat)pos;

- (BOOL)joined;
- (void)setJoined:(BOOL)active;

@end