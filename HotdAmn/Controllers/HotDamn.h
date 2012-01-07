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
#import "Socket.h"

@interface HotDamn : NSObject <NSApplicationDelegate> {
    IBOutlet TabBar *barControl;
    Socket *sock;
}

@property (readwrite, assign) BOOL tabbing;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) About *aboutPanel;

- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

- (IBAction)showAboutPanel:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

@end
