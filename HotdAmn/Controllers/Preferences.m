//
//  Preferences.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

@synthesize toolbar, general;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [toolbar setSelectedItemIdentifier:@"PrefsGeneral"];
    [self selectItem:general];
}

- (IBAction)selectItem:(id)sender
{
    NSString *nibName = [sender itemIdentifier];
    [[[self window] contentView] setSubviews:[NSArray array]];
    if (currentPanel != nil)
        [currentPanel release];
    Class cls = NSClassFromString(nibName);
    currentPanel = [[cls alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    [[[self window] contentView] addSubview:[currentPanel view]];
    [[currentPanel view] setFrame:[[[self window] contentView] frame]];
}

@end
