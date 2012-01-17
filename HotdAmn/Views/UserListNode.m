//
//  UserListNode.m
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserListNode.h"
#import "User.h"

@implementation UserListNode

@synthesize title, isLeaf, children, object;

- (id)init
{
    self = [super init];
    if (self) {
        children = [[NSMutableArray alloc] init];
        isLeaf = YES;
    }
    
    return self;
}

- (void)addChildren:(NSArray *)objects
{
    isLeaf = NO;
    children = [[NSMutableArray arrayWithArray:objects] retain];
}

- (void)addChild:(UserListNode *)obj
{
    isLeaf = NO;
    [children addObject:obj];
}

- (void)sortChildrenWithComparator:(NSComparator)cmptr
{
    [children sortUsingComparator:cmptr];
}

- (UserListNode *)childWithTitle:(NSString *)t
{
    if (isLeaf) return nil;
    for (UserListNode *n in children) {
        if ([[n title] isEqualToString:t])
            return n;
    }
    return nil;
}

- (void)removeChildWithTitle:(NSString *)titl
{
    if (isLeaf) return;
    for (int i = 0; i < [children count]; i++) {
        UserListNode *node = [children objectAtIndex:i];
        if ([[node title] isEqualToString:titl]) {
            [children removeObject:node];
            [node release];
        }
    }
}

- (void)dealloc
{
    [title release];
    [object release];
    [children release];
    [super dealloc];
}

@end
