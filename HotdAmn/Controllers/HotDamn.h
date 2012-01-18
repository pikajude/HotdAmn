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

typedef enum {
    AutojoinNone,
    AutojoinPrevious,
    AutojoinUserDefined
} autojoin;

@interface HotDamn : NSObject <NSApplicationDelegate, EventHandlerDelegate> {
    IBOutlet TabBar *barControl;
    EventHandler *evtHandler;
    Preferences *prefs;
}

@property (readwrite, assign) BOOL isConnected;
@property (readwrite, assign) BOOL tabbing;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) About *aboutPanel;

#pragma mark -
#pragma mark Tabs
- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (void)removeTabWithTitle:(NSString *)title;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

#pragma mark -
#pragma mark Panels
- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showPreferences:(id)sender;

#pragma mark -
#pragma mark Menu items
- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

#pragma mark -
#pragma mark Chat management
- (void)restartConnection;
- (void)startConnection;
- (void)stopConnection;
- (void)postMessage:(Message *)msg inRoom:(NSString *)roomName;

#pragma mark -
#pragma mark User defaults
- (void)setupDefaults;
- (void)verifyTheme;
- (void)themeFailure:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

@end
