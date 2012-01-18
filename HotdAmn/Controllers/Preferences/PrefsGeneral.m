//
//  PrefsGeneral.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PrefsGeneral.h"

@implementation PrefsGeneral

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
    int selected = [[[NSUserDefaults standardUserDefaults] objectForKey:@"autojoin"] intValue];
    [mat setState:1 atRow:selected column:0];
    if (selected == AutojoinUserDefined) {
        [self enableRoomList];
    }
}

- (void)selectMyJoin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:AutojoinUserDefined] forKey:@"autojoin"];
    [self enableRoomList];
}

- (void)selectNoJoin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:AutojoinNone] forKey:@"autojoin"];
    [self disableRoomList];
}

- (void)selectPrevJoin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:AutojoinPrevious] forKey:@"autojoin"];
    [self disableRoomList];
}

- (void)enableRoomList
{
    [rooms setEnabled:YES];
    [addButton setEnabled:YES];
}

- (void)disableRoomList
{
    [rooms setEnabled:NO];
    [addButton setEnabled:NO];
    [removeButton setEnabled:NO];
}

- (IBAction)addRoom:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *rms = [NSMutableArray arrayWithArray:[defs objectForKey:@"autojoinRooms"]];
    [rms addObject:@"room"];
    [defs setObject:rms forKey:@"autojoinRooms"];
    [rooms reloadData];
    [rooms editColumn:0 row:[rms count] - 1 withEvent:nil select:YES];
}

- (IBAction)removeRoom:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *rms = [NSMutableArray arrayWithArray:[defs objectForKey:@"autojoinRooms"]];
    if ([rooms selectedRow] == -1)
        return;
    [rms removeObjectAtIndex:[rooms selectedRow]];
    [defs setObject:rms forKey:@"autojoinRooms"];
    [rooms reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"autojoinRooms"] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [[defs objectForKey:@"autojoinRooms"] objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *rms = [NSMutableArray arrayWithArray:[defs objectForKey:@"autojoinRooms"]];
    [rms replaceObjectAtIndex:row withObject:object];
    [defs setObject:rms forKey:@"autojoinRooms"];
    [errMsg setHidden:YES];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if ([rooms selectedRow] == -1) {
        [removeButton setEnabled:NO];
    } else {
        [removeButton setEnabled:YES];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (control == rooms) {
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        NSArray *rms = [defs objectForKey:@"autojoinRooms"];
        if ([[fieldEditor string] isEqualToString:@""]) {
            return NO;
        }
        if ([rms containsObject:[fieldEditor string]]) {
            [errMsg setStringValue:@"Duplicate room name."];
            [errMsg setHidden:NO];
            return NO;
        }
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-"] invertedSet];
        if ([[fieldEditor string] rangeOfCharacterFromSet:set].location != NSNotFound) {
            [errMsg setStringValue:@"Invalid characters in room name."];
            [errMsg setHidden:NO];
            return NO;
        }
    }
    return YES;
}

@end
