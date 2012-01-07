//
//  AppController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

@implementation AppController

@synthesize appMenu, tabbing;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"awaking");
    [barControl addButtonWithTitle:@"Server"];
}

- (IBAction)addTab:(id)sender
{
    tabbing = YES;
    JoinRoom *ctrl = [[[JoinRoom alloc] initWithWindowNibName:@"JoinRoom2"] autorelease];
    [ctrl setDelegate:self];
    
    [NSApp beginSheet:[ctrl window]
       modalForWindow:[self window]
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

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[self window] setBackgroundColor:[NSColor colorWithDeviceWhite:0.88f alpha:1.0f]];
}

@end
