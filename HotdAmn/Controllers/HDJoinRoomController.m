//
//  HDJoinRoomController.m
//  HotdAmn
//
//  Created by Joel on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HDJoinRoomController.h"

@implementation HDJoinRoomController

@synthesize roomName, errMsg, delegate;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)joinRoom:(id)sender
{
	NSString *currentRoomName = [roomName stringValue];
	// dAmn only allows A-Z, a-z, and dashes.
	NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-"] invertedSet];
	
	BOOL containsBadChars = ([currentRoomName rangeOfCharacterFromSet:set].location != NSNotFound);

	if (containsBadChars) {
		[errMsg	setHidden:NO];
	} else {
		NSMutableString *room = [[[NSMutableString alloc] init] autorelease];
		if([currentRoomName characterAtIndex:0] != '#') [room appendString:@"#"];
		[room appendString:currentRoomName];
		[[self delegate] createTabWithTitle:room];
		[self cancelRoom:nil];
	}
}

- (IBAction)cancelRoom:(id)sender
{
	[[self window] orderOut:nil];
}

@end
