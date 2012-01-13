//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDamn.h"

@implementation HotDamn

@synthesize isConnected, window, appMenu, tabbing, aboutPanel;

- (id)init
{
    self = [super init];
    isConnected = NO;
    evtHandler = [[EventHandler alloc] init];
    [evtHandler setDelegate:self];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self setupDefaults];
    aboutPanel = [[About alloc] initWithWindowNibName:@"About"];
    prefs = [[Preferences alloc] initWithWindowNibName:@"Shell"];
    [barControl addButtonWithTitle:@"Server"];
    [window setBackgroundColor:[NSColor colorWithDeviceWhite:0.88f alpha:1.0f]];
    
    [[UserManager defaultManager] setDelegate:self];
    
    if ([[UserManager defaultManager] hasDefaultUser]) {
        [window makeKeyAndOrderFront:nil];
        [self startConnection];
    } else {
        [[UserManager defaultManager] startIntroduction];
    }
}

- (IBAction)addTab:(id)sender
{
    tabbing = YES;
    JoinRoom *ctrl = [[JoinRoom alloc] initWithWindowNibName:@"JoinRoom"];
    [ctrl setDelegate:evtHandler];
    
    [NSApp beginSheet:[ctrl window]
       modalForWindow:window
        modalDelegate:nil
       didEndSelector:nil
          contextInfo:nil];
    
    [NSApp endSheet:[ctrl window]];
}

- (IBAction)removeTab:(id)sender
{
    [barControl removeHighlighted];
}

- (IBAction)selectNextTab:(id)sender
{
    [barControl selectNext];
}

- (IBAction)selectPreviousTab:(id)sender
{
    [barControl selectPrevious];
}

- (void)createTabWithTitle:(NSString *)title
{
    [barControl addButtonWithTitle:title];
}

- (void)removeTabWithTitle:(NSString *)title
{
    [barControl removeButtonWithTitle:title];
}

// TODO: this
- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem
{
    if ([theMenuItem action] == @selector(addTab:) && tabbing) {
        return NO;
    }
    if ([theMenuItem action] == @selector(addTab:) && !isConnected) {
        return NO;
    }
    if (([theMenuItem action] == @selector(selectNextTab:) ||
         [theMenuItem action] == @selector(selectPreviousTab:)) &&
        [[[barControl tabView] subviews] count] < 2) {
        return NO;
    }
    return YES;
}

- (IBAction)showAboutPanel:(id)sender
{
    [[aboutPanel window] makeKeyAndOrderFront:nil];
}

- (IBAction)showPreferences:(id)sender
{
    [[prefs window] makeKeyAndOrderFront:nil];
}

- (void)startConnection
{
    if (![window isVisible]) {
        [window makeKeyAndOrderFront:nil];
    }
    NSDictionary *user = [[UserManager defaultManager] currentUser];
    [evtHandler setUser:[user retain]];
    [evtHandler startConnection];
}

- (void)postMessage:(NSString *)msg inRoom:(NSString *)roomName
{
    TabButton *b = [[barControl tabs] objectForKey:roomName];
    [b addLine:msg];
    [[b cell] setBadgeValue:[[b cell] badgeValue] + 1];
    [barControl resizeButtons];
}

- (void)setupDefaults
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *standard = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Courier New", @"mainFontName",
                              [NSNumber numberWithFloat:12.0f], @"mainFontSize",
                              [[NSFont systemFontOfSize:0.0f] fontName], @"inputFontName",
                              [NSNumber numberWithFloat:12.0f], @"inputFontSize", nil];
    [def registerDefaults:standard];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:standard];
    [def synchronize];
}

@end
