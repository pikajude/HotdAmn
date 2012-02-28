//
//  WhoisMessage.m
//  HotdAmn
//
//  Created by Joel on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhoisMessage.h"
#import "MessageFormatter.h"

@implementation WhoisMessage

@synthesize username, metadata;

- (WhoisMessage *)init
{
    self = [super init];
    connections = [[NSMutableArray array] retain];
    return self;
}

- (void)addConnection:(WConnection *)conn
{
    [connections addObject:conn];
}

- (NSString *)asHTML
{
    NSMutableString *html = [NSMutableString stringWithString:@"<div class='whois'>"];
    [html appendFormat:@"<img src='%@' width='50' height='50' />", [AvatarManager avatarURLForUsername:username userIcon:[[metadata objectForKey:@"usericon"] integerValue]]];
    [html appendFormat:@"<div class='userinfo'><h4>%@<a href='http://%@.deviantart.com'>%@</a></h4>", [metadata objectForKey:@"symbol"], username, username];
    [html appendFormat:@"<h5>%@</h5>", [metadata objectForKey:@"realname"]];
    [html appendString:@"</div><ul>"];
    
    for (WConnection *conn in connections) {
        [html appendString:@"<li><ul><li>Online: "];
        
        [html appendString:[MessageFormatter dateDifferenceToString:[conn connectionTime]]];
        
        [html appendString:@"</li><li>Idle: "];
        
        [html appendString:[MessageFormatter dateDifferenceToString:[conn idleTime]]];
        
        [html appendString:@"</li><li>Rooms: "];
        
        NSMutableArray *rooms = [NSMutableArray arrayWithArray:[[conn rooms] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        for (int i = 0; i < [rooms count]; i++) {
            NSString *rm = [rooms objectAtIndex:i];
            [rooms replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"<a href='damn://chat/%@'>#%@</a>", rm, rm]];
        }
        
        [html appendString:[rooms componentsJoinedByString:@", "]];
        [html appendString:@"</li></ul></li>"];
    }
    [html appendString:@"</ul></div>"];
    
    return html;
}

- (void)dealloc
{
    [connections release];
    [super dealloc];
}

@end
