//
//  OAuthLocalServer.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OAuthLocalServer.h"
#include <netinet/in.h>

@implementation OAuthLocalServer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)startWithDelegate:(id)delegate
{
    int reuse = true;
    sock = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, 0, NULL, NULL);
    int filedes = CFSocketGetNative(sock);
    setsockopt(filedes, SOL_SOCKET, SO_REUSEADDR, (void *)&reuse, sizeof(int));
    struct sockaddr_in address;
    memset(&address, 0, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    address.sin_port = htons(12345);
    CFDataRef addressData = CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));
    [(id)addressData autorelease];
    
    CFSocketSetAddress(sock, addressData);
    
    handle = [[NSFileHandle alloc] initWithFileDescriptor:filedes closeOnDealloc:YES];
    [[NSNotificationCenter defaultCenter] addObserver:delegate
                                             selector:@selector(receiveIncomingConnection:)
                                                 name:NSFileHandleConnectionAcceptedNotification
                                               object:nil];
    [handle acceptConnectionInBackgroundAndNotify];
}

- (void)dealloc
{
    CFRelease(sock);
    [super dealloc];
}

@end
