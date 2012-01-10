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
                  [NSValue valueWithPointer:@selector(onLogin:)], @"login",
                  [NSValue valueWithPointer:@selector(onJoin:)], @"join",
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
                [delegate performSelector:[[events objectForKey:[pkt command]] pointerValue]
                               withObject:pkt];
                
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
