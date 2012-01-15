//
//  PrefsUsers.h
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserManager.h"

@interface PrefsUsers : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView *accountList;
    IBOutlet NSTableView *buddyList;
    IBOutlet NSTableView *ignoreList;
    
    IBOutlet NSButton *accountRemoveButton;
    IBOutlet NSButton *buddyRemoveButton;
    IBOutlet NSButton *ignoreRemoveButton;
}

- (IBAction)addIgnore:(id)sender;
- (IBAction)removeIgnore:(id)sender;

- (IBAction)addBuddy:(id)sender;
- (IBAction)removeBuddy:(id)sender;

- (IBAction)addAccount:(id)sender;
- (IBAction)removeAccount:(id)sender;

@end
