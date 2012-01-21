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

+ (void)addUser:(User *)user toRoom:(NSString *)room withGroupName:(NSString *)groupName
{
    UserListNode *roomRoot;
    UserListNode *groupRoot;
    UserListNode *existingNode;
    UserListNode *userNode = [[[UserListNode alloc] init] autorelease];
    [userNode setTitle:[user username]];
    [userNode setObject:user];
    if (!roomList) {
        roomList = [[NSMutableDictionary alloc] init];
    }
    if (!(roomRoot = [roomList objectForKey:room])) {
        roomRoot = [[[UserListNode alloc] init] autorelease];
        [roomList setObject:roomRoot forKey:room];
    }
    if (!(groupRoot = [roomRoot childWithTitle:groupName])) {
        groupRoot = [[[UserListNode alloc] init] autorelease];
        [groupRoot setTitle:groupName];
        [roomRoot addChild:groupRoot];
    }
    if ((existingNode = [groupRoot childWithTitle:[user username]])) {
        [existingNode setJoinCount:[existingNode joinCount] + 1];
        return;
    }
    [groupRoot addChild:userNode];
}

+ (void)removeUser:(NSString *)user fromRoom:(NSString *)room
{
    UserListNode *roomList = [self listForRoom:room];
    if (!roomList)
        return;
    for (int i = 0; i < [[roomList children] count]; i++) {
        UserListNode *group = [[roomList children] objectAtIndex:i];
        [group removeChildWithTitle:user];
        if ([[group children] count] == 0) {
            [roomList removeChildWithTitle:[group title]];
        }
    }
}

+ (User *)userWithName:(NSString *)name inRoom:(NSString *)room
{
    UserListNode *roomList = [self listForRoom:room];
    if (!roomList)
        return nil;
    for (UserListNode *group in [roomList children]) {
        for (UserListNode *user in [group children]) {
            if ([[[user object] username] isEqualToString:name]) {
                return [user object];
            }
        }
    }
    return nil;
}

+ (void)updateWatchers
{
    for (id<UserListWatcher> watcher in watchers) {
        [watcher onUserListUpdated];
    }
}

@end
