//
//  HDApplicationController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBar.h"
#import "JoinRoom.h"
#import "About.h"
#import "EventHandler.h"
#import "DamnSocket.h"
#import "Token.h"
#import "ThemeHelper.h"
#import "UserManager.h"
#import "Preferences.h"
#import "TopicDialog.h"
#import "LuaInterop.h"
#import "ScriptList.h"

typedef enum {
    AutojoinNone,
    AutojoinPrevious,
    AutojoinUserDefined
} autojoin;

@interface HotDamn : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    IBOutlet TabBar *barControl;
    Preferences *prefs;
    BOOL topicActive;
}

@property (readwrite, assign) BOOL isConnected;
@property (readwrite, assign) BOOL tabbing;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) About *aboutPanel;
@property (readonly) EventHandler *evtHandler;

#pragma mark -
#pragma mark Tabs
- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (void)removeTabWithTitle:(NSString *)title afterPart:(BOOL)af;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;
- (void)beforeRemoval:(id)tab;
- (void)afterRemoval;

#pragma mark -
#pragma mark Panels
- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)showTopic:(id)sender;

#pragma mark -
#pragma mark Menu items
- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

#pragma mark -
#pragma mark Chat management
- (void)restartConnection;
- (void)startConnection;
- (void)stopConnection;
- (void)startPchat:(id)sender;
- (NSString *)currentRoom;

#pragma mark -
#pragma mark User defaults
- (void)setupDefaults;
- (void)verifyTheme;
- (void)onQuitAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)themeFailure:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

#pragma mark -
#pragma mark Window handling
- (void)windowDidResize:(NSNotification *)notification;

- (TabBar *)barControl;

#pragma mark -
#pragma mark Script stuff
- (NSMenuItem *)scriptMenu;
- (void)showScriptErrorLog:(id)sender;

#pragma mark -
#pragma mark Links
- (void)getURL:(NSAppleEventDescriptor *)evt withReplyEvent:(NSAppleEventDescriptor *)replyEvt;

@end
