//
//  EventHandler.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EventHandler.h"
#import "HotDamn.h"
#import "Packet.h"

@implementation EventHandler

@synthesize delegate, user;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)onPacket:(Packet *)msg
{
    
}

- (void)onServer:(Packet *)msg
{
    NSString *resp = [NSString stringWithFormat:@"login %@\npk=%@\n\0",
                      [user objectForKey:@"username"],
                      [user objectForKey:@"authtoken"]];
    [delegate postMessage:[NSString stringWithFormat:@"Logged in to dAmnServer %@.", [msg param]] 
                   inRoom:@"Server"];
    [sock write:resp];
}

- (void)onLogin:(Packet *)msg
{
    if ([[[msg args] objectForKey:@"e"] isEqualToString:@"ok"]) {
        NSLog(@"Connection succeeded.");
    } else {
        NSLog(@"Connection phail, retrying.");
        [user refreshFields];
        NSString *resp = [NSString stringWithFormat:@"login %@\npk=%@\n\0",
                          [user objectForKey:@"username"],
                          [user objectForKey:@"authtoken"]];
        [sock write:resp];
    }
}

- (void)startConnection
{
    sock = [[DamnSocket alloc] init];
    [sock setDelegate:self];
    [sock open];
    [sock write:@"dAmnClient 0.3\nagent=hotdAmn\n\0"];
}

- (void)dealloc
{
    [user release];
    [sock release];
    [super dealloc];
}

@end