//
//  HDApplicationController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDTabBarController.h"

@interface HDApplicationController : NSObject <NSApplicationDelegate> {
	IBOutlet HDTabBarController *barControl;
}

@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenu *appMenu;

- (NSString *)genRandStringLength:(int)len;

- (IBAction)removeTab:(id)sender;
- (IBAction)addTab:(id)sender;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;

@end
