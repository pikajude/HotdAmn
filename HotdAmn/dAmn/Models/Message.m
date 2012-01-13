//
//  Message.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize content, date, highlight;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithContent:(NSString *)cont
{
    self = [super init];
    content = [cont retain];
    date = [NSDate date];
    return self;
}

- (void)dealloc
{
    [content release];
    [super dealloc];
}

@end
