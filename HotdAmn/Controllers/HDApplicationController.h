//
//  HDApplicationController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDTabBarController.h"
#import "HDJoinRoomController.h"

@interface HDApplicationController : NSObject <NSApplicationDelegate> {
	IBOutlet HDTabBarController *barControl;
}

@property (readwrite, assign) BOOL tabbing;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenu *appMenu;

- (IBAction)addBadge:(id)sender;
- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

@end
