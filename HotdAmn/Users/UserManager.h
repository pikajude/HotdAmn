//
//  UserManager.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Welcome.h"
#import "NSDictionary+User.h"

@class HotDamn;

@class PrefsUsers;

@interface UserManager : NSObject {
    Welcome *win;
}

@property (assign) id delegate;

+ (UserManager *)defaultManager;

- (void)startIntroduction:(BOOL)firstTime;
- (void)finishIntroduction:(BOOL)firstTime;

- (NSString *)userFilePath;
- (NSString *)currentUsername;

- (BOOL)hasDefaultUser;
- (void)setDefaultUsername:(NSString *)username;

- (void)addUsername:(NSString *)username refreshCode:(NSString *)refreshCode accessToken:(NSString *)accessToken authToken:(NSString *)authtoken;
- (void)removeUsername:(NSString *)username;

- (void)updateRecord:(NSDictionary *)record forUsername:(NSString *)username;

- (NSArray *)userList;
- (void)saveUserList:(NSArray *)users;

- (NSMutableDictionary *)currentUser;

+ (NSString *)formatChatroom:(NSString *)username;

@end
