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

#pragma mark -
#pragma mark Socket delegate methods

- (void)onPacket:(Packet *)msg
{
    NSLog(@"%@", [msg raw]);
}

- (void)onServer:(Packet *)msg
{
    NSString *resp = [NSString stringWithFormat:@"login %@\npk=%@\n\0",
                      [user objectForKey:@"username"],
                      [user objectForKey:@"authtoken"]];
    [delegate postMessage:[NSString stringWithFormat:@"Connected to dAmnServer %@.", [msg param]] 
                   inRoom:@"Server"];
    [sock write:resp];
}

- (void)onLogin:(Packet *)msg
{
    if ([[[msg args] objectForKey:@"e"] isEqualToString:@"ok"]) {
        [delegate postMessage:[NSString stringWithFormat:@"Logged in as %@.", [msg param]]
                       inRoom:@"Server"];
        [delegate setIsConnected:YES];
    } else {
        [delegate postMessage:@"Login fail, refreshing authtoken." inRoom:@"Server"];
        [user refreshFields];
        NSString *resp = [NSString stringWithFormat:@"login %@\npk=%@\n\0",
                          [user objectForKey:@"username"],
                          [user objectForKey:@"authtoken"]];
        [sock write:resp];
    }
}

- (void)onJoin:(Packet *)msg
{
    [[self delegate] createTabWithTitle:[[msg param] substringFromIndex:5]];
}

#pragma mark -
#pragma mark Actions

- (void)join:(NSString *)roomName
{
    NSString *pk = [NSString stringWithFormat:@"join chat:%@\n\0", roomName];
    [sock write:pk];
}

#pragma mark -

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