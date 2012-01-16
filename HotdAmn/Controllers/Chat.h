//
//  Chat.h
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "Preferences.h"
#import "UserListNode.h"
#import "UserManager.h"
#import "User.h"
#import "Topic.h"
#import "Message.h"
#import "ThemeHelper.h"

@interface Chat : NSViewController <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, UserListWatcher, TopicWatcher> {
    NSMutableArray *lines;
    IBOutlet NSOutlineView *userList;
    IBOutlet NSTextField *input;
    IBOutlet WebView *chatView;
    
    IBOutlet NSTextField *username;
}

@property (assign) NSString *roomName;
@property (readonly) IBOutlet NSSplitView *split;
@property (readonly) IBOutlet NSView *chatContainer;
@property (assign) id delegate;

- (void)selectInput;

- (void)addLine:(Message *)str;

- (void)onUserListUpdated;
- (void)onTopicChange;

@end
