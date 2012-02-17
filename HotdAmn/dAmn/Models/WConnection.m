//
//  WConnection.m
//  HotdAmn
//
//  Created by Joel on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WConnection.h"

@implementation WConnection

@synthesize connectionTime, idleTime;

- (WConnection *)init {
    self = [super init];
    rooms = [[NSMutableArray array] retain];
    return self;
}

- (void)addRoom:(NSString *)room
{
    [rooms addObject:room];
}

- (NSArray *)rooms {
    return rooms;
}

- (void)dealloc
{
    [rooms release];
    [super dealloc];
}

@end
