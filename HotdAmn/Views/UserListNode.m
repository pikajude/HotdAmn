//
//  UserListNode.m
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserListNode.h"

@implementation UserListNode

@synthesize title, isLeaf, children;

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
    [children sortUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString *)[a title] compare:[b title]];
    }];
}

- (void)addChild:(UserListNode *)obj
{
    isLeaf = NO;
    [children addObject:obj];
    [children sortUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString *)[a title] compare:[b title]];
    }];
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

- (void)dealloc
{
    [children release];
    [super dealloc];
}

@end
