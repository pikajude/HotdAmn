//
//  Socket.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DamnSocket.h"

static int port = 3900;

@implementation DamnSocket

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        host = [NSHost hostWithName:@"chat.deviantart.com"];
        events = [[NSDictionary dictionaryWithObjectsAndKeys:
                  [NSValue valueWithPointer:@selector(onServer:)], @"dAmnServer",
                  [NSValue valueWithPointer:@selector(onPing:)], @"ping",
                  [NSValue valueWithPointer:@selector(onLogin:)], @"login",
                  [NSValue valueWithPointer:@selector(onJoin:)], @"join",
                  [NSValue valueWithPointer:@selector(onPropertyMembers:)], @"property_members",
                  [NSValue valueWithPointer:@selector(onPropertyPrivclasses:)], @"property_privclasses",
                  [NSValue valueWithPointer:@selector(onPropertyTopic:)], @"property_topic",
                  [NSValue valueWithPointer:@selector(onRecvJoin:)], @"recv_join",
                  [NSValue valueWithPointer:@selector(onRecvPart:)], @"recv_part",
                  [NSValue valueWithPointer:@selector(onRecvMsg:)], @"recv_msg",
                  nil] retain];
        
        buf = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)open
{
    [NSStream getStreamsToHost:host
                          port:port
                   inputStream:&istream
                  outputStream:&ostream];
    
    [istream setDelegate:self];
    [ostream setDelegate:self];
    
    [istream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [ostream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [istream retain];
    [ostream retain];
    
    [istream open];
    [ostream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if (aStream == istream) {
        [self handleInputStreamEvent:eventCode];
    } else {
        [self handleOutputStreamEvent:eventCode];
    }
}

- (void)handleInputStreamEvent:(NSStreamEvent)evt
{
    switch (evt) {
        case NSStreamEventHasBytesAvailable: {
            // Receive one char at a time, looking for NUL
            uint8_t *buffer = malloc(sizeof(uint8_t));
            [istream read:buffer maxLength:1];
            
            // Found NUL, end of packet
            if (buffer[0] == '\0') {
                NSString *str = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
                Packet *pkt = [[[Packet alloc] initWithString:str] autorelease];
                [delegate onPacket:pkt];
                NSLog(@"%@", [self eventName:pkt]);
                SEL sel = [[events objectForKey:[self eventName:pkt]] pointerValue];
                if (sel && [delegate respondsToSelector:sel]) {
                    [delegate performSelector:sel withObject:pkt];
                }
                
                // Clear buffer
                [buf release];
                buf = [[NSMutableData alloc] init];
            } else {
                [buf appendBytes:(const void *)buffer length:1];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)handleOutputStreamEvent:(NSStreamEvent)evt
{
    
}

- (void)write:(NSString *)toWrite
{
    NSData *dat = [toWrite dataUsingEncoding:NSUTF8StringEncoding];
    [ostream write:(uint8_t *)[dat bytes] maxLength:[dat length]]; // [dat ass];
}

- (NSString *)eventName:(Packet *)pkt
{
    if ([[pkt command] isEqualToString:@"property"]) {
        NSString *pee = [[pkt args] objectForKey:@"p"];
        return [NSString stringWithFormat:@"property_%@",
                [pee hasPrefix:@"login:"] ? @"whois" : pee];
    } else if ([[pkt command] isEqualToString:@"recv"]) {
        NSInteger idx = (NSInteger)[[pkt body] rangeOfString:@" "].location;
        return [NSString stringWithFormat:@"recv_%@", [[pkt body] substringToIndex:idx]];
    } else {
        return [pkt command];
    }
}

- (void)dealloc
{
    [buf release];
    [istream close];
    [ostream close];
    [istream release];
    [ostream release];
    [super dealloc];
}

@end
