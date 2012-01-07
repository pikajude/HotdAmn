//
//  AppController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDTabBarController.h"
#import "JoinRoom.h"

@interface AppController : NSWindowController <NSApplicationDelegate> {
    IBOutlet HDTabBarController *barControl;
}

@property (readwrite, assign) BOOL tabbing;
@property (retain) IBOutlet NSMenu *appMenu;

- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (void)createTabWithTitle:(NSString *)title;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem;

@end
