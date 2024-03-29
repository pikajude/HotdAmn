//
//  PrefsAppearance.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HotDamn.h"
#import "ThemeHelper.h"

@interface PrefsAppearance : NSViewController <NSWindowDelegate, NSTableViewDataSource, NSControlTextEditingDelegate, NSTableViewDelegate> {
    IBOutlet NSTextField *chatFont;
    IBOutlet NSTextField *inputFont;
    IBOutlet NSTableView *highlights;
    IBOutlet NSButton *chooseButton1;
    IBOutlet NSButton *chooseButton2;
    IBOutlet NSButton *removeHighlightButton;
    NSTextField *currentField;
    IBOutlet NSTextField *scrollbackErr;
    
    IBOutlet NSArrayController *themes;
}

- (NSFont *)getMainFont;
- (NSFont *)getInputFont;

- (IBAction)selectAFont:(id)sender;

- (void)updateFont:(NSFont *)font forField:(NSString *)fieldName;

- (void)windowWillClose:(NSNotification *)notification;

- (IBAction)addTableItem:(id)sender;
- (IBAction)removeTableItem:(id)sender;

@end
