//
//  BuddyCommand.m
//  HotdAmn
//
//  Created by Joel on 1/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BuddyCommand.h"

@implementation BuddyCommand

- (id)init
{
    self = [super init];
    [self setTypes:[NSArray arrayWithObjects:
                    [NSNumber numberWithInt:ArgTypeCustom],
                    [NSNumber numberWithInt:ArgTypeUsername], nil]];
    return self;
}

- (NSInteger)arity
{
    return 2;
}

- (commandBlock)command
{
    return ^(Chat *caller, id<ChatDelegate>receiver, NSArray *args)
    {
        NSLog(@"%@", args);
    };
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
