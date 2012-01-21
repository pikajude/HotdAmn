//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDamn.h"

@implementation HotDamn

@synthesize isConnected, window, appMenu, tabbing, aboutPanel, evtHandler;

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
    [self verifyTheme];
    aboutPanel = [[About alloc] initWithWindowNibName:@"About"];
    prefs = [[Preferences alloc] initWithWindowNibName:@"Shell"];
    [barControl addButtonWithTitle:@"Server"];
    [window setBackgroundColor:[NSColor colorWithDeviceWhite:0.88f alpha:1.0f]];
    
    [[UserManager defaultManager] setDelegate:self];
    
    if ([[UserManager defaultManager] hasDefaultUser]) {
        [window makeKeyAndOrderFront:nil];
        [self startConnection];
    } else {
        [[UserManager defaultManager] startIntroduction:YES];
    }
}

- (void)verifyTheme
{
    NSArray *themes = [ThemeHelper themeList];
    NSAlert *al = [NSAlert alertWithMessageText:@"Theme error"
                                  defaultButton:@"OK"
                                alternateButton:nil
                                    otherButton:nil
                      informativeTextWithFormat:@""];
    if ([themes count] < 1) {
        [al setInformativeText:@"You can't run HotdAmn without at least one theme. What did you do with the default, silly?"];
        [al beginSheetModalForWindow:nil
                       modalDelegate:self
                      didEndSelector:@selector(themeFailure:returnCode:contextInfo:)
                         contextInfo:nil];
    } else if (![themes containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"themeName"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:[themes objectAtIndex:0] forKey:@"themeName"];
    }
}

- (void)themeFailure:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [[NSApplication sharedApplication] terminate:nil];
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

- (void)restartConnection
{
    [self stopConnection];
    [self startConnection];
}

- (void)startConnection
{
    if (![window isVisible]) {
        [window makeKeyAndOrderFront:nil];
    }
    NSMutableDictionary *user = [[UserManager defaultManager] currentUser];
    [[[[barControl tabs] objectForKey:@"Server"] chatRoom] onTopicChange];
    [evtHandler setUser:user];
    [evtHandler startConnection];
}

- (void)stopConnection
{
    [evtHandler stopConnection];
}

- (void)postMessage:(Message *)msg inRoom:(NSString *)roomName
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
                              [NSNumber numberWithFloat:12.0f], @"inputFontSize",
                              [NSArray array], @"highlights",
                              [NSArray array], @"buddies",
                              [NSArray array], @"ignores",
                              [NSNumber numberWithInteger:500], @"scrollbackLimit",
                              @"Default", @"themeName",
                              @"[%H:%M:%S]", @"timestampFormat",
                              [NSNumber numberWithBool:YES], @"WebKitDeveloperExtras",
                              [NSNumber numberWithInt:AutojoinNone], @"autojoin",
                              [NSArray array], @"autojoinRooms",
                              [NSArray array], @"savedRooms", nil];
    [def registerDefaults:standard];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:standard];
    [def synchronize];
}

@end
