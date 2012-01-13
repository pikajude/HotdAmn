//
//  User.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username, symbol, usericon, avatar;

- (User *)initWithUsername:(NSString *)user userIcon:(NSInteger)userIcon symbol:(char)sym
{
    self = [super init];
    username = user;
    usericon = userIcon;
    symbol = sym;
    
    // Grab the avatar asynchronously, since it could take awhile
    [[[NSThread alloc] initWithTarget:[AvatarManager class] selector:@selector(setAvatarForUser:) object:self] start];
    return self;
}

- (void)dealloc
{
    free((void *)&symbol);
    [super dealloc];
}

@end
