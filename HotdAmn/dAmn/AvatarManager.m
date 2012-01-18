//
//  AvatarManager.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AvatarManager.h"
#import "User.h"

static NSString *avatars[] = {@".gif", @".gif", @".jpg", @".png"};

@implementation AvatarManager

// This method should be called asynchronously
// (that's why it doesn't return anything,
// but modifies the user object)
+ (void)setAvatarForUser:(User *)user
{
    NSImage *avatar = [[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[self avatarURLForUsername:[user username] userIcon:[user usericon]]]] autorelease];
    if (user != nil)
        [user setAvatar:avatar];
}

+ (NSString *)avatarURLForUsername:(NSString *)username userIcon:(NSInteger)userIcon
{
    NSString *cachebuster = @"";
    NSString *urlsection = @"default";
    NSInteger a = userIcon;
    NSInteger cbust = (a >> 2) & 15;
    a &= 3;
    NSString *ext = avatars[a];
    if (!ext)
        ext = avatars[0];
    if (cbust > 0)
        cachebuster = [NSString stringWithFormat:@"?%ld", cbust];
    if (a > 0)
        urlsection = [NSString stringWithFormat:@"%c/%c/%@",
                      [username characterAtIndex:0],
                      [username characterAtIndex:1],
                      username];
    NSString *url = [NSString stringWithFormat:@"http://a.deviantart.com/avatars/%@%@%@",
                     urlsection,
                     ext,
                     cachebuster];
    return url;
}

@end
