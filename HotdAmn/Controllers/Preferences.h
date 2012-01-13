//
//  Preferences.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PreferenceUpdateDelegate <NSObject>

- (void)inputFontDidChange;
- (void)chatFontDidChange;

@end

@interface Preferences : NSWindowController {
    NSViewController *currentPanel;
    NSDictionary *panelNames;
}

@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSToolbarItem *general;

- (IBAction)selectItem:(id)sender;

@end
