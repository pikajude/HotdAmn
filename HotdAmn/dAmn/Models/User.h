//
//  User.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarManager.h"
#import "UserListNode.h"

@protocol UserListWatcher <NSObject>

- (void)onUserListUpdated;

@end

@class Chat;

@interface User : NSObject

- (User *)initWithUsername:(NSString *)username userIcon:(NSInteger)userIcon symbol:(char)symbol;

@property (readonly) NSString *username;
@property (readonly) NSInteger usericon;
@property (readonly) char symbol;
@property (assign) NSImage *avatar;

- (NSImage *)avatar;

+ (void)addUser:(User *)user toRoom:(NSString *)room withGroupName:(NSString *)groupName;
+ (User *)userWithName:(NSString *)name inRoom:(NSString *)room;
+ (void)removeUser:(NSString *)user fromRoom:(NSString *)room;
+ (void)removeRoom:(NSString *)room;
+ (void)addWatcher:(id<UserListWatcher>)watcher;
+ (void)removeWatcher:(id<UserListWatcher>)watcher;
+ (UserListNode *)listForRoom:(NSString *)roomName;
+ (void)updateWatchers;

@end
