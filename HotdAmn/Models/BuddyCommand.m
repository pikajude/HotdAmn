//
//  BuddyCommand.m
//  HotdAmn
//
//  Created by Joel on 1/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BuddyCommand.h"

@implementation BuddyCommand

commandBlock action = ^(Chat *caller, id<ChatDelegate>receiver, NSArray *args) {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *buddies = [NSMutableArray arrayWithArray:[defs objectForKey:@"buddies"]];
    if ([args count] == 0) {
        [caller error:@"Possible arguments: add, remove, list."];
        return;
    }
    
    if ([[args objectAtIndex:0] isEqualToString:@"list"]) {
        
        NSArray *buddies = [defs objectForKey:@"buddies"];
        [caller error:[NSString stringWithFormat:@"Buddies: %@", [buddies componentsJoinedByString:@", "]]];
        
    } else if ([[args objectAtIndex:0] isEqualToString:@"add"]) {
        
        NSArray *newBuddies = [args subarrayWithRange:NSMakeRange(1, [args count] - 1)];
        [buddies addObjectsFromArray:newBuddies];
        [buddies setArray:[[NSSet setWithArray:buddies] allObjects]];
        [defs setObject:buddies forKey:@"buddies"];
        for(NSString *buddy in newBuddies) {
            [caller error:[NSString stringWithFormat:@"Added %@ to buddy list.", buddy]];
        }
        
    } else if ([[args objectAtIndex:0] isEqualToString:@"remove"]) {
        
        if ([buddies containsObject:[args objectAtIndex:1]]) {
            [buddies removeObject:[args objectAtIndex:1]];
            [defs setObject:buddies forKey:@"buddies"];
        } else {
            [caller error:[NSString stringWithFormat:@"%@ is not one of your buddies.", [args objectAtIndex:1]]];
        }
        
    } else {
        [caller error:[NSString stringWithFormat:@"Unknown command %@. Valid commands are add, remove, and list.", [args objectAtIndex:0]]];
    }
};

- (id)init
{
    self = [super init];
    [self setTypes:[NSArray arrayWithObjects:
                    [NSNumber numberWithInt:ArgTypeCustom],
                    [NSNumber numberWithInt:ArgTypeUsername], nil]];
    [self setCommand:action];
    return self;
}

- (NSInteger)arity
{
    return 2;
}

- (NSArray *)completionsForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return [NSArray arrayWithObjects:@"add", @"remove", @"list", nil];
            
        default:
            return [NSArray array];
    }
}

@end
