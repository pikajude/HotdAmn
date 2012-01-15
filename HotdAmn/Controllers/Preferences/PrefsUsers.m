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
    NSInteger accountCount = [self numberOfRowsInTableView:accountList];
    if (accountCount < 2) {
        [accountRemoveButton setEnabled:NO];
    }
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
        NSArray *users = [[UserManager defaultManager] userList];
        return [[users objectAtIndex:row] objectForKey:@"username"];
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
        } else {
            [accountRemoveButton setEnabled:YES];
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
