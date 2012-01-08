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
                  nil] retain];
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
            uint8_t *buf = malloc(sizeof(uint8_t) * 8192);
            NSInteger len = [istream read:buf maxLength:8192];
            NSData *dat = [NSData dataWithBytes:buf length:len];
            free(buf);
            NSString *str = [[[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding] autorelease];
            Packet *pkt = [[[Packet alloc] initWithString:str] autorelease];
            [delegate onPacket:pkt];
            [delegate performSelector:[[events objectForKey:[pkt command]] pointerValue]
                           withObject:pkt];
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
    [istream close];
    [ostream close];
    [istream release];
    [ostream release];
    [super dealloc];
}

@end
