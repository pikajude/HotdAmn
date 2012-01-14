//
//  User.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

static NSMutableArray *watchers;
static NSMutableDictionary *roomList;

@implementation User

@synthesize username, symbol, usericon, avatar;

- (User *)initWithUsername:(NSString *)user userIcon:(NSInteger)userIcon symbol:(char)sym
{
    self = [super init];
    username = user;
    usericon = userIcon;
    symbol = sym;
    
    // Grab the avatar asynchronously, since it could take awhile
    [[[[NSThread alloc] initWithTarget:[AvatarManager class] selector:@selector(setAvatarForUser:) object:self] autorelease] start];
    return self;
}

+ (void)addWatcher:(id<UserListWatcher>)watcher
{
    if (!watchers) {
        watchers = [[NSMutableArray alloc] init];
    }
    [watchers addObject:watcher];
}

+ (UserListNode *)listForRoom:(NSString *)roomName
{
    if (!roomList) return nil;
    return [roomList objectForKey:roomName];
}

+ (void)addUser:(NSString *)user toRoom:(NSString *)room withGroupName:(NSString *)groupName
{
    UserListNode *roomRoot;
    UserListNode *groupRoot;
    UserListNode *userNode = [[UserListNode alloc] init];
    [userNode setTitle:[user retain]];
    if (!roomList) {
        roomList = [[NSMutableDictionary alloc] init];
    }
    if (!(roomRoot = [roomList objectForKey:room])) {
        roomRoot = [[UserListNode alloc] init];
        [roomList setObject:roomRoot forKey:room];
    }
    if (!(groupRoot = [roomRoot childWithTitle:groupName])) {
        groupRoot = [[UserListNode alloc] init];
        [groupRoot setTitle:[groupName retain]];
        [roomRoot addChild:groupRoot];
    }
    if ([groupRoot childWithTitle:user]) {
        [[userNode title] release];
        [userNode release];
        return;
    }
    [groupRoot addChild:userNode];
}

+ (void)updateWatchers
{
    for (id<UserListWatcher> watcher in watchers) {
        [watcher onUserListUpdated];
    }
}

- (void)dealloc
{
    free((void *)&symbol);
    [super dealloc];
}

@end
