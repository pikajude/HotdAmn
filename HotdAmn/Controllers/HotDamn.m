//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotDamn.h"

@implementation HotDamn

@synthesize window, appMenu, tabbing, aboutPanel;

- (id)init
{
    self = [super init];
    if (self) {
        sock = [[Socket alloc] init];
        NSLog(@"%@", sock);
    }
    
    return self;
}

- (void)awakeFromNib
{
    aboutPanel = [[About alloc] initWithWindowNibName:@"About"];
    [barControl addButtonWithTitle:@"Server"];
    [window setBackgroundColor:[NSColor colorWithDeviceWhite:0.88f alpha:1.0f]];
    [sock open];
    [sock write:@"dAmnClient 0.3\nagent=hotdAmn\n\0"];
}

- (IBAction)addTab:(id)sender
{
    tabbing = YES;
    JoinRoom *ctrl = [[JoinRoom alloc] initWithWindowNibName:@"JoinRoom"];
    [ctrl setDelegate:self];
    
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

// TODO: this
- (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem
{
    if ([theMenuItem action] == @selector(addTab:) && tabbing) {
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

@end
