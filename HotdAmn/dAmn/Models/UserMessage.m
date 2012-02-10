//
//  UserMessage.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserMessage.h"

@implementation UserMessage

@synthesize user, highlight = _highlight;

- (UserMessage *)initWithContent:(NSString *)content user:(User *)usr
{
    self = [super initWithContent:content];
    user = usr;
    
    NSMutableArray *highlights = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highlights"]];
    [highlights addObject:[[UserManager defaultManager] currentUsername]];
    
    if (![[highlights lastObject] isEqualToString:[[self user] username]])
        for (NSString *match in highlights)
            if ([content rangeOfString:match].location != NSNotFound) {
                _highlight = YES;
                break;
            }
    
    return self;
}

- (NSString *)asText
{
    return [NSString stringWithFormat:@"<%c%@> %@",
            [[self user] symbol],
            [[self user] username],
            [self content]];
}

@end
