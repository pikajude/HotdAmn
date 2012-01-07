//
//  JoinRoom.m
//  HotdAmn
//
//  Created by Joel on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JoinRoom.h"
#import "AppController.h"

@implementation JoinRoom

@synthesize roomName, errMsg, delegate;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)joinRoom:(id)sender
{
    NSString *currentRoomName = [roomName stringValue];
    // dAmn only allows A-Z, a-z, and dashes.
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-"] invertedSet];
    
    BOOL containsBadChars = ([currentRoomName rangeOfCharacterFromSet:set].location != NSNotFound);

    if ([currentRoomName isEqualToString:@""] || containsBadChars) {
        [errMsg setHidden:NO];
    } else {
        NSMutableString *room = [[[NSMutableString alloc] init] autorelease];
        if([currentRoomName characterAtIndex:0] != '#') [room appendString:@"#"];
        [room appendString:currentRoomName];
        [[self delegate] createTabWithTitle:room];
        
        // not actually canceling, this is just a shortcut
        [self cancelRoom:nil];
    }
}

- (IBAction)cancelRoom:(id)sender
{
    [[self window] orderOut:nil];
    [[self delegate] setTabbing:NO];
}

@end
