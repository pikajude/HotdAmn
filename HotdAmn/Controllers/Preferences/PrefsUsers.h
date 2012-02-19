//
//  PrefsUsers.h
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserManager.h"
#import "HotDamn.h"

NSMutableArray *fieldForUser(NSString *field, NSString *username);
void addObjectToFieldForUser(id value, NSString *field, NSString *username);
void removeObjectFromFieldForUser(id value, NSString *field, NSString *username);
void removeObjectAtIndexFromFieldForUser(NSInteger index, NSString *field, NSString *username);
void setFieldAtIndexForUser(id value, NSInteger index, NSString *field, NSString *username);

@interface PrefsUsers : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView *accountList;
    IBOutlet NSTableView *buddyList;
    IBOutlet NSTableView *ignoreList;
    
    IBOutlet NSButton *accountRemoveButton;
    IBOutlet NSButton *buddyRemoveButton;
    IBOutlet NSButton *ignoreRemoveButton;
    IBOutlet NSButton *accountUseButton;
}

- (IBAction)addIgnore:(id)sender;
- (IBAction)removeIgnore:(id)sender;

- (IBAction)addBuddy:(id)sender;
- (IBAction)removeBuddy:(id)sender;

- (IBAction)addAccount:(id)sender;
- (IBAction)removeAccount:(id)sender;
- (IBAction)useAccount:(id)sender;

- (void)beforeDisplay;

- (void)addAccountAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

- (void)accountAdded;

@end
