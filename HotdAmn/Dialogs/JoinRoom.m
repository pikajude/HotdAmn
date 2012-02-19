//
//  HDJoinRoomController.m
//  HotdAmn
//
//  Created by Joel on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JoinRoom.h"
#import "HotDamn.h"

@implementation JoinRoom

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

    if ([currentRoomName isEqualToString:@""] || containsBadChars) {
        [errMsg setHidden:NO];
    } else {
        NSMutableString *str = [currentRoomName mutableCopy];
        if ([str characterAtIndex:0] != '#')
            [str insertString:@"#" atIndex:0];
        [[self delegate] join:str];
        
        // not actually canceling, this is just a shortcut
        [self cancelRoom:nil];
    }
}

- (IBAction)cancelRoom:(id)sender
{
    [[self window] orderOut:nil];
    [[[self delegate] delegate] setTabbing:NO];
}

@end
