//
//  PrefsUsers.m
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PrefsUsers.h"

@implementation PrefsUsers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == accountList) {
        return [[[UserManager defaultManager] userList] count];
    } else if (tableView == buddyList) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"buddies"] count];
    } else {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"ignores"] count];
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
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"buddies"] objectAtIndex:row];
    } else {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"ignores"] objectAtIndex:row];
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *items;
    NSString *key;
    if (tableView == buddyList) {
        key = @"buddies";
    } else {
        key = @"ignores";
    }
    items = [NSMutableArray arrayWithArray:[defs objectForKey:key]];
    [items replaceObjectAtIndex:row withObject:object];
    [defs setObject:items forKey:key];
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
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *buddies = [NSMutableArray arrayWithArray:[defs objectForKey:@"buddies"]];
    
    // Add a new username
    [buddies addObject:@"username"];
    [defs setObject:buddies forKey:@"buddies"];
    
    // Select the added item
    [buddyList reloadData];
    [buddyList editColumn:0 row:[buddies count] - 1 withEvent:nil select:YES];
}

- (IBAction)removeBuddy:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *buddies = [NSMutableArray arrayWithArray:[defs objectForKey:@"buddies"]];
    [buddies removeObjectAtIndex:[buddyList selectedRow]];
    [defs setObject:buddies forKey:@"buddies"];
    [buddyList reloadData];
}

- (IBAction)addIgnore:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ignores = [NSMutableArray arrayWithArray:[defs objectForKey:@"ignores"]];
    
    [ignores addObject:@"username"];
    [defs setObject:ignores forKey:@"ignores"];
    
    [ignoreList reloadData];
    [ignoreList editColumn:0 row:[ignores count] - 1 withEvent:nil select:YES];
}

- (IBAction)removeIgnore:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ignores = [NSMutableArray arrayWithArray:[defs objectForKey:@"ignores"]];
    [ignores removeObjectAtIndex:[ignoreList selectedRow]];
    [defs setObject:ignores forKey:@"ignores"];
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
    if (username == [[man currentUser] objectForKey:@"username"])
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
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    if (control == buddyList) {
        return ![[defs objectForKey:@"buddies"] containsObject:[fieldEditor string]];
    } else {
        return ![[defs objectForKey:@"ignores"] containsObject:[fieldEditor string]];
    }
}

@end
