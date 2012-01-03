//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HDApplicationController.h"

const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation HDApplicationController

@synthesize window, appMenu, tabbing;

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
	[barControl addButtonWithTitle:@"Server"];
}

- (NSString *)genRandStringLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
	}
		 
	return randomString;
}

- (IBAction)addTab:(id)sender
{
	tabbing = YES;
	HDJoinRoomController *ctrl = [[HDJoinRoomController alloc] initWithWindowNibName:@"JoinRoom"];
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

- (void)addBadge:(id)sender
{
	[[[[[barControl tabView] subviews] lastObject] cell] setBadgeValue:rand() % 1000000];
	[barControl resizeButtons];
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
	[window setBackgroundColor:[NSColor colorWithDeviceWhite:0.88f alpha:1.0f]];
}

@end
