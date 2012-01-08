//
//  UserManager.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

const UserManager *man;

@implementation UserManager

@synthesize delegate;

+ (UserManager *)defaultManager
{
    if (!man) {
        man = [[UserManager alloc] init];
    }
    return (UserManager *)man;
}

- (NSString *)userFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         NO);
    return [[[[[paths objectAtIndex:0]
              stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]]
              stringByAppendingPathComponent:@"Users"]
              stringByAppendingPathComponent:@"users.plist"] stringByExpandingTildeInPath];
}

- (BOOL)hasDefaultUser
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self userFilePath]];
}

- (NSArray *)userList
{
    return [NSArray arrayWithContentsOfFile:[self userFilePath]];
}

- (void)startIntroduction
{
    win = [[Welcome alloc] initWithWindowNibName:@"Welcome"];
    [[win window] makeKeyAndOrderFront:nil];
}

- (void)finishIntroduction
{
    [[win window] orderOut:nil];
    [[win webWindow] orderOut:nil];
    [delegate startConnection];
}

- (void)saveUserList:(NSArray *)users
{
    if (![self hasDefaultUser]) {
        NSString *dirname = [[self userFilePath] substringToIndex:[[self userFilePath] length] - 12];
        [[NSFileManager defaultManager] createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [users writeToFile:[self userFilePath] atomically:YES];
}

- (void)addUsername:(NSString *)username refreshCode:(NSString *)refreshCode accessToken:(NSString *)accessToken authToken:(NSString *)authtoken
{
    NSMutableArray *users;
    
    NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          username, @"username",
                          refreshCode, @"refreshcode",
                          accessToken, @"accesstoken",
                          authtoken, @"authtoken",
                          [NSNumber numberWithBool:NO], @"default", nil];
    
    if ([self hasDefaultUser]) {
        users = [[[self userList] mutableCopy] autorelease];
        [users addObject:user];
    } else {
        users = [NSMutableArray array];
        [user setObject:[NSNumber numberWithBool:YES] forKey:@"default"];
        [users addObject:user];
    }
    
    [self saveUserList:users];
}

- (NSDictionary *)currentUser
{
    NSArray *users = [NSArray arrayWithContentsOfFile:[self userFilePath]];
    for (NSMutableDictionary *user in users) {
        if ([[user objectForKey:@"default"] boolValue] == YES) {
            return user;
        }
    }
    return [users objectAtIndex:0];
}

@end
