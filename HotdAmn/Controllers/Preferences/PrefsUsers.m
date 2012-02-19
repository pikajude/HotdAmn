//
//  PrefsUsers.m
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PrefsUsers.h"

NSMutableArray *fieldForUser(NSString *field, NSString *username) {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[defs objectForKey:field]];
    if ([dict objectForKey:username] == nil) {
        [dict setObject:[NSArray array] forKey:username];
        [defs setObject:dict forKey:field];
    }
    return [NSMutableArray arrayWithArray:[[defs objectForKey:field] objectForKey:username]];
}

void addObjectToFieldForUser(id value, NSString *field, NSString *username) {
    NSMutableArray *items = fieldForUser(field, username);
    [items addObject:value];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[defs objectForKey:field]];
    [dict setObject:items forKey:username];
    [defs setObject:dict forKey:field];
}

void removeObjectFromFieldForUser(id value, NSString *field, NSString *username) {
    NSMutableArray *items = fieldForUser(field, username);
    [items removeObject:value];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[defs objectForKey:field]];
    [dict setObject:items forKey:username];
    [defs setObject:dict forKey:field];
}

void removeObjectAtIndexFromFieldForUser(NSInteger index, NSString *field, NSString *username) {
    NSMutableArray *items = fieldForUser(field, username);
    [items removeObjectAtIndex:index];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[defs objectForKey:field]];
    [dict setObject:items forKey:username];
    [defs setObject:dict forKey:field];
}

void setFieldAtIndexForUser(id value, NSInteger index, NSString *field, NSString *username) {
    NSMutableArray *items = fieldForUser(field, username);
    [items replaceObjectAtIndex:index withObject:value];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[defs objectForKey:field]];
    [dict setObject:items forKey:username];
    [defs setObject:dict forKey:field];
}

@implementation PrefsUsers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)beforeDisplay
{
    [ignoreList reloadData];
    [buddyList reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == accountList) {
        return [[[UserManager defaultManager] userList] count];
    } else if (tableView == buddyList) {
        return [fieldForUser(@"buddies", [[UserManager defaultManager] currentUsername]) count];
    } else {
        return [fieldForUser(@"ignores", [[UserManager defaultManager] currentUsername]) count];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == accountList) {
        if ([[tableColumn identifier] isEqualToString:@"text"]) {
            NSArray *users = [[UserManager defaultManager] userList];
            return [[users objectAtIndex:row] objectForKey:@"username"];
        } else {
            
            // This is the user column
            if ([[[[UserManager defaultManager] userList] objectAtIndex:row] isEqualToDictionary:[[UserManager defaultManager] currentUser]]) {
                
                // This is the active user, so display the check mark
                return [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check" ofType:@"png"]] autorelease];
            } else {
                
                // Not the active user, display nothing
                return [[[NSImage alloc] init] autorelease];
            }
        }
    } else if (tableView == buddyList) {
        return [fieldForUser(@"buddies", [[UserManager defaultManager] currentUsername]) objectAtIndex:row];
    } else {
        return [fieldForUser(@"ignores", [[UserManager defaultManager] currentUsername]) objectAtIndex:row];
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *key;
    if (tableView == buddyList) {
        key = @"buddies";
    } else {
        key = @"ignores";
    }
    setFieldAtIndexForUser(object, row, key, [[UserManager defaultManager] currentUsername]);
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if ([notification object] == buddyList) {
        if ([buddyList selectedRow] == -1) {
            [buddyRemoveButton setEnabled:NO];
        } else {
            [buddyRemoveButton setEnabled:YES];
        }
    } else if ([notification object] == accountList) {
        if ([accountList selectedRow] == -1 || [[[UserManager defaultManager] userList] count] < 2) {
            [accountRemoveButton setEnabled:NO];
            [accountUseButton setEnabled:NO];
        } else {
            [accountRemoveButton setEnabled:YES];
            [accountUseButton setEnabled:YES];
        }
    } else {
        if ([ignoreList selectedRow] == -1) {
            [ignoreRemoveButton setEnabled:NO];
        } else {
            [ignoreRemoveButton setEnabled:YES];
        }
    }
}

- (IBAction)addBuddy:(id)sender
{
    addObjectToFieldForUser(@"username", @"buddies", [[UserManager defaultManager] currentUsername]);
    
    // Select the added item
    [buddyList reloadData];
    [buddyList editColumn:0 row:[buddyList numberOfRows] - 1 withEvent:nil select:YES];
}

- (IBAction)removeBuddy:(id)sender
{
    removeObjectAtIndexFromFieldForUser([buddyList selectedRow], @"buddies", [[UserManager defaultManager] currentUsername]);
    [buddyList reloadData];
}

- (IBAction)addIgnore:(id)sender
{
    addObjectToFieldForUser(@"username", @"ignores", [[UserManager defaultManager] currentUsername]);
    
    [ignoreList reloadData];
    [ignoreList editColumn:0 row:[ignoreList numberOfRows] - 1 withEvent:nil select:YES];
}

- (IBAction)removeIgnore:(id)sender
{
    removeObjectAtIndexFromFieldForUser([ignoreList selectedRow], @"ignores", [[UserManager defaultManager] currentUsername]);
    [ignoreList reloadData];
}

- (IBAction)addAccount:(id)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"Hey you!"
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"Before you add a new account, remember to log in as that user on deviantART in your nearest web browser."];
    [alert beginSheetModalForWindow:[[self view] window]
                      modalDelegate:self
                     didEndSelector:@selector(addAccountAlertDidEnd:returnCode:contextInfo:) 
                        contextInfo:nil];
}

- (IBAction)removeAccount:(id)sender
{
    NSString *informativeText;
    NSDictionary *user = [[[UserManager defaultManager] userList] objectAtIndex:[accountList selectedRow]];
    if ([user isEqualToDictionary:[[UserManager defaultManager] currentUser]]) {
        informativeText = @"That account is currently in use; removing it will disconnect you from dAmn.";
    } else {
        informativeText = @"Deleting an account can't be undone.";
    }
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure?"
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:informativeText];
    [alert beginSheetModalForWindow:[[self view] window]
                      modalDelegate:self
                     didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                        contextInfo:[user retain]];
}

- (IBAction)useAccount:(id)sender
{
    UserManager *man = [UserManager defaultManager];
    NSString *username = [[[man userList] objectAtIndex:[accountList selectedRow]] objectForKey:@"username"];
    if (username == [man currentUsername])
        return;
    [man setDefaultUsername:username];
    [(HotDamn *)[[NSApplication sharedApplication] delegate] restartConnection];
    [accountList reloadData];
}

- (void)addAccountAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    switch (returnCode) {
        case NSOKButton: {
            [[UserManager defaultManager] setDelegate:self];
            [[UserManager defaultManager] startIntroduction:NO];
            break;
        }
            
        default:
            break;
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSDictionary *user = (NSDictionary *)contextInfo;
    switch (returnCode) {
        case NSOKButton: {
            UserManager *man = [UserManager defaultManager];
            if ([user isEqualToDictionary:[man currentUser]]) {
                [(HotDamn *)[[NSApplication sharedApplication] delegate] stopConnection];
            }
            [man removeUsername:[user objectForKey:@"username"]];
            [man setDefaultUsername:[[[man userList] objectAtIndex:0] objectForKey:@"username"]];
            [user autorelease];
            [accountList reloadData];
            break;
        }
            
        default:
            break;
    }
}

- (void)accountAdded
{
    [accountList reloadData];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString *username = [[UserManager defaultManager] currentUsername];
    if (control == buddyList) {
        return ![fieldForUser(@"buddies", username) containsObject:[fieldEditor string]];
    } else {
        return ![fieldForUser(@"ignores", username) containsObject:[fieldEditor string]];
    }
}

@end
