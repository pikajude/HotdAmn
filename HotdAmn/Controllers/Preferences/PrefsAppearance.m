//
//  PrefsAppearance.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PrefsAppearance.h"

@implementation PrefsAppearance

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSFont *)getMainFont
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [NSFont fontWithName:[defs objectForKey:@"mainFontName"]
                           size:[[defs objectForKey:@"mainFontSize"] floatValue]];
}

- (NSFont *)getInputFont
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [NSFont fontWithName:[defs objectForKey:@"inputFontName"]
                           size:[[defs objectForKey:@"inputFontSize"] floatValue]];
}

- (void)awakeFromNib
{
    NSFont *mfont = [self getMainFont];
    NSFont *ifont = [self getInputFont];
    
    [chatFont setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                              [mfont displayName],
                              [mfont pointSize]]];
    
    [inputFont setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                               [ifont displayName],
                               [ifont pointSize]]];
    
    [themes setContent:[ThemeHelper themeList]];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)selectAFont:(id)sender
{
    [chooseButton1 setEnabled:NO];
    [chooseButton2 setEnabled:NO];
    if (sender == chooseButton1) {
        currentField = chatFont;
    } else {
        currentField = inputFont;
    }
    NSFont *mfont = [self getMainFont];
    NSFontManager *fontMan = [NSFontManager sharedFontManager];
    [fontMan setDelegate:self];
    [fontMan setTarget:self];
    [fontMan setSelectedFont:mfont isMultiple:NO];
    
    NSFontPanel *p = [fontMan fontPanel:YES];
    [p setDelegate:self];
    [p makeKeyAndOrderFront:nil];
}

- (void)changeFont:(id)sender
{
    if (currentField == chatFont) {
        [self updateFont:[sender convertFont:[self getMainFont]] forField:@"main"];
    } else {
        [self updateFont:[sender convertFont:[self getInputFont]] forField:@"input"];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    [chooseButton1 setEnabled:YES];
    [chooseButton2 setEnabled:YES];
    currentField = nil;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateFont:(NSFont *)font forField:(NSString *)fieldName
{
    NSTextField *field;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *sizeField = [NSString stringWithFormat:@"%@FontSize", fieldName];
    NSString *nameField = [NSString stringWithFormat:@"%@FontName", fieldName];
    
    [def setObject:[NSNumber numberWithFloat:[font pointSize]] forKey:sizeField];
    [def setObject:[font displayName] forKey:nameField];
    
    if ([fieldName isEqualToString:@"main"]) {
        field = chatFont;
    } else {
        field = inputFont;
    }
    
    [field setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                           [font displayName],
                           [font pointSize]]];
}

- (IBAction)addTableItem:(id)sender
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[defs objectForKey:@"highlights"]];
    [ary addObject:@"new highlight"];
    [defs setObject:ary forKey:@"highlights"];
    [highlights reloadData];
    [highlights editColumn:0 row:[ary count] - 1 withEvent:nil select:YES];
    [removeHighlightButton setEnabled:YES];
}

- (IBAction)removeTableItem:(id)sender
{
    // if no row is selected, stop here
    if ([highlights selectedRow] == -1)
        return;
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[defs objectForKey:@"highlights"]];
    [ary removeObjectAtIndex:[highlights selectedRow]];
    
    // disable the remove-highlight button if none exist
    if ([ary count] == 0)
        [removeHighlightButton setEnabled:NO];
    
    // update highlight list
    [defs setObject:ary forKey:@"highlights"];
    [highlights reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [[defs objectForKey:@"highlights"] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [[defs objectForKey:@"highlights"] objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *h = [NSMutableArray arrayWithArray:[defs objectForKey:@"highlights"]];
    [h replaceObjectAtIndex:row withObject:object];
    [defs setObject:h forKey:@"highlights"];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // Enable/disable the remove button based on whether
    // a row is selected
    if ([highlights selectedRow] == -1) {
        [removeHighlightButton setEnabled:NO];
    } else {
        [removeHighlightButton setEnabled:YES];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (control == highlights) {
        
        // If we're in the highlights list
        // If the highlight is empty, it of course
        // shouldn't be valid
        return ![[fieldEditor string] isEqualToString:@""];
        
    } else {
        NSString *str = [fieldEditor string];
        
        // We're in the scrollback chooser
        // If it contains non-numeric characters, it's invalid
        if ([str rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
            [scrollbackErr setHidden:NO];
            return NO;
        }
        
        // If the integer value is outside [100, 10000] it's invalid
        if ([str integerValue] < 100 || [str integerValue] > 10000) {
            [scrollbackErr setHidden:NO];
            return NO;
        }
        [scrollbackErr setHidden:YES];
        return YES;
    }
}

@end
