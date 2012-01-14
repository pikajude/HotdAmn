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
        privclasses = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}

#pragma mark -
#pragma mark Socket delegate methods

- (void)onPacket:(Packet *)msg
{
    // NSLog(@"%@", [msg raw]);
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
    if ([msg isOkay]) {
        [[self delegate] createTabWithTitle:[msg roomWithOctothorpe]];
        [delegate postMessage:@"Joined successfully." inRoom:@"Server"];
        [privclasses setObject:[[NSMutableDictionary dictionary] retain] forKey:[msg roomName]];
    } else {
        [delegate postMessage:[NSString stringWithFormat:@"Failed to join room: %@", [[msg args] objectForKey:@"e"]] inRoom:@"Server"];
    }
}

- (void)onPart:(Packet *)msg
{
    [[self delegate] removeTabWithTitle:[msg roomWithOctothorpe]];
}

- (void)onPropertyMembers:(Packet *)msg
{
    NSMutableDictionary *rm = [privclasses objectForKey:[msg roomName]];
    NSArray *subpackets = [[msg body] componentsSeparatedByString:@"\n\n"];
    for (NSString *pk in subpackets) {
        if ([pk isEqualToString:@""])
            continue;
        Packet *p = [[[Packet alloc] initWithString:pk] autorelease];
        [User addUser:[p param] toRoom:[msg roomWithOctothorpe] withGroupName:[[p args] objectForKey:@"pc"]];
    }
    [[User listForRoom:[msg roomWithOctothorpe]] sortChildrenWithComparator:^NSComparisonResult(id obj1, id obj2) {
        return [rm levelForPrivclass:[obj1 title]] < [rm levelForPrivclass:[obj2 title]] ? NSOrderedDescending : NSOrderedAscending;
    }];
    [User updateWatchers];
}

- (void)onPropertyPrivclasses:(Packet *)msg
{
    NSMutableDictionary *room;
    if (!(room = [privclasses objectForKey:[msg roomName]])) {
        room = [[NSMutableDictionary alloc] init];
        [privclasses setObject:room forKey:[msg roomName]];
    }
    NSArray *pairs = [[msg body] componentsSeparatedByString:@"\n"];
    for (NSString *pair in pairs) {
        if ([pair isEqualToString:@""])
            continue;
        NSArray *whatever = [pair componentsSeparatedByString:@":"];
        [room addPrivclass:[whatever objectAtIndex:1] withLevel:[[whatever objectAtIndex:0] integerValue]];
    }
}

- (void)onPropertyTopic:(Packet *)msg
{
    [Topic setTopic:[msg body] forRoom:[msg roomWithOctothorpe]];
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
    [privclasses release];
    [user release];
    [sock release];
    [super dealloc];
}

@end