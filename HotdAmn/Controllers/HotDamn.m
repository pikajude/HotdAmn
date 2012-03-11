//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDamn.h"
#import "EventHandler.h"

@implementation HotDamn

@synthesize isConnected, window, appMenu, tabbing, aboutPanel, evtHandler;

- (id)init
{
    self = [super init];
    isConnected = NO;
    evtHandler = [[EventHandler alloc] init];
    [evtHandler setDelegate:self];
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getURL:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"values.advanced"]) {
        BOOL val = [[[NSUserDefaults standardUserDefaults] objectForKey:@"advanced"] boolValue];
        if (val) {
            [appMenu addItem:[self scriptMenu]];
        } else
            if ([appMenu itemWithTitle:@"Script"])
                [appMenu removeItem:[appMenu itemWithTitle:@"Script"]];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self setupDefaults];
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                                              forKeyPath:@"values.advanced"
                                                                 options:NSKeyValueObservingOptionNew
                                                                 context:nil];
    [self observeValueForKeyPath:@"values.advanced"
                        ofObject:nil
                          change:nil
                         context:nil];
    [self verifyTheme];
    aboutPanel = [[About alloc] initWithWindowNibName:@"About"];
    prefs = [[Preferences alloc] initWithWindowNibName:@"Shell"];
    [barControl addButtonWithTitle:@"Server"];
    [window setContentBorderThickness:4.0f forEdge:NSMaxYEdge];
    [window setAutorecalculatesContentBorderThickness:NO forEdge:NSMaxYEdge];
    
    [[LuaInterop lua] loadBuiltins];
    [[LuaInterop lua] loadUserDefined];
    
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
    [self beforeRemoval:[barControl highlightedTab]];
    [barControl removeHighlighted];
    [self afterRemoval];
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

- (void)removeTabWithTitle:(NSString *)title afterPart:(BOOL)af
{
    if(!af) [self beforeRemoval:[barControl getButtonWithTitle:title]];
    [barControl removeButtonWithTitle:title];
    [self afterRemoval];
}

- (void)beforeRemoval:(id)tab
{
    [evtHandler part:[tab title]];
}

- (void)afterRemoval
{
    if ([[barControl highlightedTab] chatRoom])
        [[[barControl highlightedTab] chatRoom] onTopicChange];
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
        ([[[barControl tabView] subviews] count] < 2 ||
         topicActive)) {
        return NO;
    }
    if ([theMenuItem action] == @selector(showTopic:) && [[[barControl highlightedTab] title] isEqualToString:@"Server"]) {
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
    [prefs beforeDisplay];
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
    [[[barControl getButtonWithTitle:@"Server"] chatRoom] onTopicChange];
    [evtHandler setUser:user];
    [evtHandler startConnection];
}

- (void)stopConnection
{
    [evtHandler stopConnection];
}

- (NSString *)currentRoom
{
    return [[barControl highlightedTab] roomName];
}

- (void)setupDefaults
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *standard = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Courier New", @"mainFontName",
                              [NSNumber numberWithFloat:12.0f], @"mainFontSize",
                              [[NSFont systemFontOfSize:0.0f] fontName], @"inputFontName",
                              [NSNumber numberWithFloat:12.0f], @"inputFontSize",
                              [NSDictionary dictionary], @"highlights",
                              [NSDictionary dictionary], @"buddies",
                              [NSDictionary dictionary], @"ignores",
                              [NSNumber numberWithInteger:500], @"scrollbackLimit",
                              @"Default", @"themeName",
                              @"[%H:%M:%S]", @"timestampFormat",
                              [NSNumber numberWithBool:YES], @"WebKitDeveloperExtras",
                              [NSNumber numberWithInt:AutojoinNone], @"autojoin",
                              [NSDictionary dictionary], @"autojoinRooms",
                              [NSNumber numberWithBool:NO], @"closeOnPart",
                              [NSNumber numberWithBool:NO], @"advanced",
                              [NSArray array], @"savedRooms", nil];
    [def registerDefaults:standard];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:standard];
    [def synchronize];
}

- (void)windowDidResize:(NSNotification *)notification
{
    [barControl resizeButtons];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [evtHandler stopConnection]; // disconnect cleanly
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure you want to quit?"
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"Quitting will disconnect you from dAmn and stuff. Are you sure you want to continue?"];
    
    [alert beginSheetModalForWindow:nil // make it a popup, not a sheet
                      modalDelegate:self
                     didEndSelector:@selector(onQuitAlertDidEnd:returnCode:contextInfo:)
                        contextInfo:nil];
    
    return NSTerminateLater;
}

- (void)onQuitAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [NSApp replyToApplicationShouldTerminate:returnCode == NSOKButton];
}

- (IBAction)showTopic:(id)sender
{
    topicActive = YES;
    TopicDialog *d = [[TopicDialog alloc] initWithContents:[Topic topicForRoom:[[barControl highlightedTab] title]]
                                                  roomName:[[barControl highlightedTab] title]];
    [d setDelegate:self];
    [NSApp beginSheet:[d window]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:@selector(onTopicAlertDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (void)startPchat:(id)sender
{
    [evtHandler join:[sender representedObject]];
}

- (void)onTopicAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    topicActive = NO;
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
    return NSOffsetRect(rect, 0.0f, 3.0f);
}

- (TabBar *)barControl
{
    return barControl;
}

- (NSMenuItem *)scriptMenu
{
    NSMenuItem *parent = [[[NSMenuItem alloc] initWithTitle:@""
                                                     action:nil
                                              keyEquivalent:@""] autorelease];
    NSMenu *container = [[[NSMenu alloc] initWithTitle:@"Script"] autorelease];
    [parent setSubmenu:container];
    
    NSMenuItem *errors = [[[NSMenuItem alloc] initWithTitle:@"Errors (0)"
                                                     action:@selector(showScriptErrorLog:)
                                              keyEquivalent:@"s"] autorelease];
    [errors setTarget:self];
    
    [container addItem:errors];
    return parent;
}

- (void)showScriptErrorLog:(id)sender
{
    ScriptList *b = [[ScriptList alloc] initWithWindowNibName:@"ScriptList"];
    [[b window] makeKeyAndOrderFront:nil];
}

- (void)getURL:(NSAppleEventDescriptor *)evt withReplyEvent:(NSAppleEventDescriptor *)replyEvt
{
    NSString *url = [[evt paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *parsed = [NSURL URLWithString:url];
    NSCharacterSet *invalid = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"] invertedSet];
    if (!parsed) return;
    NSString *arg;
    if ([[parsed pathComponents] count] < 2)
        return;
    arg = [[parsed pathComponents] objectAtIndex:1];
    if ([arg rangeOfCharacterFromSet:invalid].location != NSNotFound)
        return;
    if ([[parsed host] isEqualToString:@"chat"]) {
        [evtHandler join:[NSString stringWithFormat:@"#%@", arg]];
    } else if ([[parsed host] isEqualToString:@"pchat"]) {
        [evtHandler join:arg];
    }
}

@end
