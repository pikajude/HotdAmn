//
//  UserMessage.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserMessage.h"

@implementation UserMessage

@synthesize user, highlight;

- (UserMessage *)initWithContent:(NSString *)content user:(User *)usr
{
    self = [super initWithContent:content];
    user = usr;
    
    NSMutableArray *highlights = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highlights"]];
    [highlights addObject:[[[UserManager defaultManager] currentUser] objectForKey:@"username"]];
    
    for (NSString *match in highlights) {
        if ([content rangeOfString:match].location != NSNotFound) {
            highlight = YES;
            break;
        }
    }
    
    return self;
}

- (NSString *)asHTML
{
    return [NSString stringWithFormat:@"<li class='%@'><timestamp>%@</timestamp> <username>%c%@</username> <line>%@</line></li>",
            [self cssClasses],
            [self timestamp],
            [[self user] symbol],
            [[self user] username],
            [[self content] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
}

@end
