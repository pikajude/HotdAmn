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
#import "UserManager.h"
#import "Preferences.h"

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

- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (void)removeTabWithTitle:(NSString *)title;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showPreferences:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

- (void)startConnection;

- (void)postMessage:(NSString *)msg inRoom:(NSString *)roomName;

@end
