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

@synthesize delegate, username, token;

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
    NSLog(@"Connected to server.");
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
    [sock release];
    [super dealloc];
}

@end