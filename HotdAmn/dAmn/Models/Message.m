//
//  Message.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize content, date;

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

- (User *)user {
    static User *servUser;
    if (!servUser) {
        servUser = [[User alloc] initWithUsername:@"dAmnServer" userIcon:0 symbol:'+'];
    }
    return servUser;
}

- (BOOL)highlight {
    return NO;
}

- (NSString *)cssClasses
{
    NSMutableArray *classes = [NSMutableArray arrayWithObject:@"message"];
    if ([self highlight]) [classes addObject:@"highlight"];
    if ([[[self user] username] isEqualToString:[[[UserManager defaultManager] currentUser] objectForKey:@"username"]]) {
        [classes addObject:@"mine"];
    }
    [classes addObject:[NSString stringWithFormat:@"user-%@", [[self user] username]]];
    return [classes componentsJoinedByString:@" "];
}

- (void)dealloc
{
    [content release];
    [super dealloc];
}

@end
