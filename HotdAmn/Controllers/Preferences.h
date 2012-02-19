//
//  Preferences.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Preferences : NSWindowController <NSWindowDelegate> {
    NSViewController *currentPanel;
    NSDictionary *panelNames;
}

@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSToolbarItem *general;

- (IBAction)selectItem:(id)sender;
- (void)beforeDisplay;

@end
