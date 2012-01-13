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
    return [NSFont fontWithName:[defs objectForKey:@"chat.mainFont.name"]
                           size:[[defs objectForKey:@"chat.mainFont.size"] floatValue]];
}

- (NSFont *)getInputFont
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [NSFont fontWithName:[defs objectForKey:@"chat.inputFont.name"]
                           size:[[defs objectForKey:@"chat.inputFont.size"] floatValue]];
}

- (void)awakeFromNib
{
    NSFont *mfont = [self getMainFont];
    NSFont *ifont = [self getInputFont];
    
    [chatFont setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                              [mfont displayName],
                              [mfont pointSize]]];
    [chatFont setFont:mfont];
    [inputFont setFont:ifont];
    
    [inputFont setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                               [ifont displayName],
                               [ifont pointSize]]];
}

- (IBAction)chooseAlignment:(id)sender
{
    NSLog(@"%@", [[sender selectedItem] title]);
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
    NSString *sizeField = [NSString stringWithFormat:@"chat.%@Font.size", fieldName];
    NSString *nameField = [NSString stringWithFormat:@"chat.%@Font.name", fieldName];
    
    [def setObject:[NSNumber numberWithFloat:[font pointSize]] forKey:sizeField];
    [def setObject:[font displayName] forKey:nameField];
    
    if ([fieldName isEqualToString:@"main"]) {
        field = chatFont;
        [(HotDamn *)[[NSApplication sharedApplication] delegate] chatFontDidChange];
    } else {
        field = inputFont;
        [(HotDamn *)[[NSApplication sharedApplication] delegate] inputFontDidChange];
    }
    
    [field setFont:font];
    [field setStringValue:[NSString stringWithFormat:@"%@ %.1f",
                           [font displayName],
                           [font pointSize]]];
}

@end
