//
//  PrefsGeneral.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HotDamn.h"

@interface PrefsGeneral : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSMatrix *mat;
    IBOutlet NSTableView *rooms;
    
    IBOutlet NSTextField *errMsg;
    
    IBOutlet NSButton *addButton;
    IBOutlet NSButton *removeButton;
}

- (IBAction)selectNoJoin:(id)sender;
- (IBAction)selectPrevJoin:(id)sender;
- (IBAction)selectMyJoin:(id)sender;

- (IBAction)addRoom:(id)sender;
- (IBAction)removeRoom:(id)sender;

- (void)enableRoomList;
- (void)disableRoomList;

@end
