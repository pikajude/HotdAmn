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

+ (void)setAvatarForUser:(User *)user
{
    NSString *cachebuster = @"";
    NSString *username = [user username];
    NSString *urlsection = @"default";
    NSInteger a = [user usericon];
    NSInteger cbust = (a >> 2) & 15;
    a &= 3;
    NSString *ext = avatars[a];
    if (!ext)
        ext = avatars[0];
    if (cbust > 0)
        cachebuster = [NSString stringWithFormat:@"?%ld", cbust];
    if (a > 0)
        urlsection = [NSString stringWithFormat:@"%c/%c/",
                      [username characterAtIndex:0],
                      [username characterAtIndex:1]];
    NSString *url = [NSString stringWithFormat:@"http://a.deviantart.com/avatars/%@%@%@",
                     urlsection,
                     ext,
                     cachebuster];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    if (user != nil)
        [user setAvatar:image];
}

@end
