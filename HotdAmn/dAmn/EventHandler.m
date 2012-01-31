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

@synthesize delegate, user, privclasses;

- (id)init
{
    self = [super init];
    if (self) {
        privclasses = [[NSMutableDictionary dictionary] retain];
        disconnecting = NO;
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
    Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"Connected to dAmnServer %@.", [msg param]]] autorelease];
    [delegate postMessage:m inRoom:@"Server"];
    disconnecting = NO;
    [sock write:resp];
}

- (void)onPing:(Packet *)msg
{
    [sock write:@"pong\n\0"];
}

- (void)onLogin:(Packet *)msg
{
    if ([[[msg args] objectForKey:@"e"] isEqualToString:@"ok"]) {
        Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"Logged in as %@.", [msg param]]] autorelease];
        [delegate postMessage:m inRoom:@"Server"];
        [delegate setIsConnected:YES];
        [[UserManager defaultManager] updateRecord:user forUsername:[msg param]];
        [self onLaunch];
    } else {
        Message *m = [[[Message alloc] initWithContent:@"Login fail, refreshing authtoken."] autorelease];
        [delegate postMessage:m inRoom:@"Server"];
        [user refreshFields];
        [sock release];
        [self startConnection];
    }
}

- (void)onLaunch
{
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"autojoin"] intValue]) {
        case AutojoinPrevious:
            for (NSString *roomName in [[NSUserDefaults standardUserDefaults] objectForKey:@"savedRooms"]) {
                [self join:roomName];
            }
            break;
            
        case AutojoinUserDefined:
            for (NSString *roomName in [[NSUserDefaults standardUserDefaults] objectForKey:@"autojoinRooms"]) {
                [self join:roomName];
            }
            
        default:
            break;
    }
}

- (void)onJoin:(Packet *)msg
{
    if ([msg isOkay]) {
        [[self delegate] createTabWithTitle:[msg roomName]];
        Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"Joined %@.", [msg roomName]]] autorelease];
        [delegate postMessage:m inRoom:@"Server"];
        [privclasses setObject:[NSMutableDictionary dictionary] forKey:[msg roomName]];
    } else {
        Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"Failed to join room: %@", [[msg args] objectForKey:@"e"]]] autorelease];
        [delegate postMessage:m inRoom:@"Server"];
    }
}

- (void)onPart:(Packet *)msg
{
    [privclasses removeObjectForKey:[msg roomName]];
    [User removeRoom:[msg roomName]];
    [[self delegate] removeTabWithTitle:[msg roomName]];
    [Topic removeRoom:[msg roomName]];
}

- (void)onPropertyMembers:(Packet *)msg
{
    NSMutableDictionary *rm = [privclasses objectForKey:[msg roomName]];
    NSArray *subpackets = [[msg body] componentsSeparatedByString:@"\n\n"];
    for (NSString *pk in subpackets) {
        if ([pk isEqualToString:@""])
            continue;
        Packet *p = [[[Packet alloc] initWithString:pk] autorelease];
        User *us = [[[User alloc] initWithUsername:[p param] userIcon:[[[p args] objectForKey:@"usericon"] integerValue] symbol:[[[p args] objectForKey:@"symbol"] characterAtIndex:0]] autorelease];
        [User addUser:us toRoom:[msg roomName] withGroupName:[[p args] objectForKey:@"pc"]];
    }
    [[User listForRoom:[msg roomName]] sortChildrenWithComparator:^NSComparisonResult(id obj1, id obj2) {
        return [rm levelForPrivclass:[obj1 title]] < [rm levelForPrivclass:[obj2 title]] ? NSOrderedDescending : NSOrderedAscending;
    }];
    [User updateWatchers];
}

- (void)onPropertyPrivclasses:(Packet *)msg
{
    NSMutableDictionary *room;
    if (!(room = [privclasses objectForKey:[msg roomName]])) {
        room = [NSMutableDictionary dictionary];
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
    [Topic setTopic:[Tablumps removeTablumps:[msg body]] forRoom:[msg roomName]];
}

- (void)onRecvJoin:(Packet *)msg
{
    Packet *p = [[[Packet alloc] initWithString:[[[msg subpacket] raw] stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"]] autorelease];
    User *us = [[[User alloc] initWithUsername:[p param] userIcon:[[[p args] objectForKey:@"usericon"] integerValue] symbol:[[[p args] objectForKey:@"symbol"] characterAtIndex:0]] autorelease];
    [User addUser:us toRoom:[msg roomName] withGroupName:[[p args] objectForKey:@"pc"]];
    
    Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"%@ has joined %@", [us username], [msg roomName]]] autorelease];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *rooms = [NSMutableArray arrayWithArray:[defs objectForKey:@"savedRooms"]];
    if (![rooms containsObject:[msg roomName]]) {
        [rooms addObject:[msg roomName]];
        [defs setObject:rooms forKey:@"savedRooms"];
    }
    
    NSArray *buddies = [defs objectForKey:@"buddies"];
    for (NSString *buddy in buddies) {
        if ([buddy isEqualToString:[p param]]) {
            [m setHighlight:YES];
            break;
        }
    }
    
    [[self delegate] postMessage:m inRoom:[msg roomName]];
    
    [User updateWatchers];
}

- (void)onRecvPart:(Packet *)msg
{
    Message *m = [[[Message alloc] initWithContent:[NSString stringWithFormat:@"%@ has parted %@", [[msg subpacket] param], [msg roomName]]] autorelease];
    [[self delegate] postMessage:m inRoom:[msg roomName]];
    [User removeUser:[[msg subpacket] param] fromRoom:[msg roomName]];
    
    if (!disconnecting) {
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        NSMutableArray *rooms = [NSMutableArray arrayWithArray:[defs objectForKey:@"savedRooms"]];
        [rooms removeObject:[msg roomName]];
        [defs setObject:rooms forKey:@"savedRooms"];
    }
    
    [User updateWatchers];
}

- (void)onRecvMsg:(Packet *)msg
{
    UserMessage *m = [[[UserMessage alloc] initWithContent:[Tablumps removeTablumps:[[msg subpacket] body]] user:[User userWithName:[[[msg subpacket] args] objectForKey:@"from"] inRoom:[msg roomName]]] autorelease];
    [[self delegate] postMessage:m inRoom:[msg roomName]];
}

- (void)onRecvAction:(Packet *)msg
{
    UserAction *m = [[[UserAction alloc] initWithContent:[Tablumps removeTablumps:[[msg subpacket] body]] user:[User userWithName:[[[msg subpacket] args] objectForKey:@"from"] inRoom:[msg roomName]]] autorelease];
    [[self delegate] postMessage:m inRoom:[msg roomName]];
}

#pragma mark -
#pragma mark Actions

- (void)join:(NSString *)room
{
    if ([room rangeOfString:@":"].location != NSNotFound) {
        [sock write:[NSString stringWithFormat:@"join pchat:%@\n\0", room]];
    } else {
        [sock write:[NSString stringWithFormat:@"join chat:%@\n\0",
                     [room stringByReplacingOccurrencesOfString:@"#" withString:@""]]];
    }
}

- (void)part:(NSString *)room
{
    [sock write:[NSString stringWithFormat:@"part chat:%@\n\0",
                 [room stringByReplacingOccurrencesOfString:@"#" withString:@""]]];
}

- (void)say:(NSString *)line inRoom:(NSString *)room
{
    NSString *pk = [NSString stringWithFormat:@"send chat:%@\n\nmsg main\n\n%@\0",
                    [room stringByReplacingOccurrencesOfString:@"#" withString:@""],
                    line];
    [sock write:pk];
}

- (void)sayUnparsed:(NSString *)str inRoom:(NSString *)room
{
    NSString *pk = [NSString stringWithFormat:@"send chat:%@\n\nnpmsg main\n\n%@\0",
                    [room stringByReplacingOccurrencesOfString:@"#" withString:@""],
                    str];
    [sock write:pk];
}

- (void)action:(NSString *)line inRoom:(NSString *)room
{
    NSString *pk = [NSString stringWithFormat:@"send chat:%@\n\naction main\n\n%@\0",
                    [room stringByReplacingOccurrencesOfString:@"#" withString:@""],
                    line];
    [sock write:pk];
}

- (void)kick:(NSString *)us fromRoom:(NSString *)room
{
    NSString *pk = [NSString stringWithFormat:@"kick chat:%@\nu=%@\n\n\0",
                    [room stringByReplacingOccurrencesOfString:@"#" withString:@""],
                    us];
    [sock write:pk];
}

- (void)kick:(NSString *)us fromRoom:(NSString *)room withReason:(NSString *)reason
{
    NSString *pk = [NSString stringWithFormat:@"kick chat:%@\nu=%@\n\n%@\n\0",
                    [room stringByReplacingOccurrencesOfString:@"#" withString:@""],
                    us,
                    reason];
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

- (void)stopConnection
{
    for (NSString *room in [privclasses allKeys]) {
        [[self delegate] removeTabWithTitle:room];
        [User removeRoom:room];
        [privclasses removeObjectForKey:room];
        [Topic removeRoom:room];
        [self part:room];
    }
    [sock write:@"disconnect\n\0"];
    [sock release];
}

- (void)dealloc
{
    [privclasses release];
    [user release];
    if (sock) [sock release];
    [super dealloc];
}

@end