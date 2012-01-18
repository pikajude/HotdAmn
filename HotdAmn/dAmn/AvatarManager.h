//
//  AvatarManager.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface AvatarManager : NSObject

+ (void)setAvatarForUser:(User *)user;
+ (NSString *)avatarURLForUsername:(NSString *)username userIcon:(NSInteger)userIcon;

@end
