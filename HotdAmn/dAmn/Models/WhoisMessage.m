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
    NSLog(@"%@", self);
    NSMutableString *html = [NSMutableString stringWithString:@"<div class='whois'>"];
    [html appendFormat:@"<img src='%@' />", [AvatarManager avatarURLForUsername:username userIcon:[[metadata objectForKey:@"usericon"] integerValue]]];
    [html appendFormat:@"<div class='userinfo'><h4>%@<a href='http://%@.deviantart.com'>%@</a></h4>", [metadata objectForKey:@"symbol"], username, username];
    [html appendFormat:@"<h5>%@</h5>", [metadata objectForKey:@"realname"]];
    [html appendString:@"</div><ul>"];
    for (WConnection *conn in connections) {
        [html appendString:@"<li><ul>"];
        
        [html appendString:@"<li>Online: "];
        [html appendString:[MessageFormatter dateDifferenceToString:[conn connectionTime]]];
        [html appendString:@"</li>"];
        
        [html appendString:@"<li>Idle: "];
        [html appendString:[MessageFormatter dateDifferenceToString:[conn idleTime]]];
        [html appendString:@"</li>"];
        
        [html appendString:@"<li>Rooms: #"];
        [html appendString:[[[conn rooms] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] componentsJoinedByString:@", #"]];
        [html appendString:@"</li>"];
        
        [html appendString:@"</ul></li>"];
    }
    [html appendString:@"</ul></div>"];
    return html;
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:[metadata description]];
    [desc appendString:[connections description]];
    return desc;
}

- (void)dealloc
{
    [connections release];
    [super dealloc];
}

@end
