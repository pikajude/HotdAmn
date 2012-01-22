//
//  Chat.h
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Growl/Growl.h>
#import "Preferences.h"
#import "UserListNode.h"
#import "UserManager.h"
#import "User.h"
#import "Topic.h"
#import "Message.h"
#import "UserMessage.h"
#import "ThemeHelper.h"
#import "TabCompletion.h"

@class HotDamn;

@interface Chat : NSViewController <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, UserListWatcher, TopicWatcher, NSTextFieldDelegate> {
    NSMutableArray *lines;
    IBOutlet NSOutlineView *userList;
    IBOutlet NSTextField *input;
    IBOutlet WebView *chatView;
    IBOutlet NSView *cShell;
    IBOutlet NSView *uShell;
    
    IBOutlet NSTextField *username;
}

@property (assign) NSString *roomName;
@property (readonly) IBOutlet NSSplitView *split;
@property (readonly) IBOutlet NSView *chatContainer;
@property (assign) id delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil roomName:(NSString *)name;

- (void)selectInput;

- (void)addLine:(Message *)str;

- (NSMenu *)menuForOutlineView:(NSOutlineView *)view byItem:(id)item;

- (void)say:(id)sender;
- (void)userError:(NSString *)errMsg;

#pragma mark -
#pragma mark Theme management
- (void)loadTheme:(NSString *)html;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

#pragma mark -
#pragma mark Event management
- (void)onUserListUpdated;
- (void)onTopicChange;

@end
