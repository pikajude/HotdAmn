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

@interface UserManager : NSObject {
    Welcome *win;
}

@property (assign) id delegate;

+ (UserManager *)defaultManager;

- (void)startIntroduction;
- (void)finishIntroduction;

- (NSString *)userFilePath;

- (BOOL)hasDefaultUser;
- (void)setDefaultUsername:(NSString *)username;

- (void)addUsername:(NSString *)username refreshCode:(NSString *)refreshCode accessToken:(NSString *)accessToken authToken:(NSString *)authtoken;

- (NSArray *)userList;
- (void)saveUserList:(NSArray *)users;

- (NSDictionary *)currentUser;

@end
