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
#import "MessageFormatter.h"
#import "UserMessage.h"
#import "ThemeHelper.h"
#import "TabCompletion.h"

@class HotDamn;

@interface Chat : NSViewController <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, UserListWatcher, TopicWatcher, NSTextFieldDelegate> {
    NSMutableArray *lines;
    IBOutlet NSTextField *input;
    IBOutlet WebView *chatView;
    IBOutlet NSView *cShell;
    IBOutlet NSView *uShell;
}

@property (retain) NSString *roomName;
@property (readonly) IBOutlet NSSplitView *split;
@property (readonly) IBOutlet NSView *chatContainer;
@property (readonly) IBOutlet NSOutlineView *userList;
@property (assign) id delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil roomName:(NSString *)name;

- (void)selectInput;

- (void)onMessage:(NSNotification *)message;

- (NSMenu *)menuForOutlineView:(NSOutlineView *)view byItem:(id)item;

- (void)say:(id)sender unparsed:(BOOL)unparsed;
- (void)error:(NSString *)errMsg;

- (BOOL)isPchat;

- (void)addBuddy:(id)sender;
- (void)removeBuddy:(id)sender;
- (void)addIgnore:(id)sender;
- (void)removeIgnore:(id)sender;

#pragma mark -
#pragma mark Theme management
- (void)loadTheme:(NSString *)html;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

#pragma mark -
#pragma mark Event management
- (void)onUserListUpdated;
- (void)onTopicChange;

#pragma mark -
- (void)whois:(id)sender;

@end
