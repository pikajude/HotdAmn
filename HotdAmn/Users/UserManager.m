//
//  UserManager.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "HotDamn.h"
#import "PrefsUsers.h"

@implementation UserManager

@synthesize delegate;

+ (UserManager *)defaultManager
{
    static UserManager *man = nil;
    if (!man) {
        man = [[UserManager alloc] init];
    }
    return man;
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

- (void)setDefaultUsername:(NSString *)username
{
    NSArray *list = [self userList];
    for (NSMutableDictionary *dict in list) {
        if ([[dict objectForKey:@"username"] isEqualToString:username]) {
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"default"];
        } else {
            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"default"];
        }
    }
    [self saveUserList:list];
}

- (NSArray *)userList
{
    return [NSArray arrayWithContentsOfFile:[self userFilePath]];
}

- (void)startIntroduction:(BOOL)firstTime
{
    win = [[Welcome alloc] initWithWindowNibName:@"Welcome"];
    [win setFirstTime:firstTime];
    if (firstTime) {
        [[win window] makeKeyAndOrderFront:nil];
    } else {
        [win getStarted:nil];
    }
}

- (void)finishIntroduction:(BOOL)firstTime
{
    [[win window] orderOut:nil];
    [[win webWindow] orderOut:nil];
    if (firstTime) {
        [delegate startConnection];
    } else {
        [delegate accountAdded];
    }
}

- (void)saveUserList:(NSArray *)users
{
    if (![self hasDefaultUser]) {
        NSString *dirname = [[self userFilePath] stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [users writeToFile:[self userFilePath] atomically:YES];
}

- (void)addUsername:(NSString *)username refreshCode:(NSString *)refreshCode accessToken:(NSString *)accessToken authToken:(NSString *)authtoken
{
    NSMutableArray *users;
    
    for (NSDictionary *user in [self userList]) {
        if ([[user objectForKey:@"username"] isEqualToString:username]) {
            return;
        }
    }
    
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

- (void)removeUsername:(NSString *)username
{
    NSMutableArray *users = [NSMutableArray arrayWithArray:[self userList]];
    NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
    NSDictionary *user;
    for (NSInteger i = 0; i < [users count]; i++) {
        user = [users objectAtIndex:i];
        if ([[user objectForKey:@"username"] isEqualToString:username]) {
            [indices addIndex:i];
        }
    }
    [users removeObjectsAtIndexes:indices];
    [self saveUserList:users];
}

- (NSMutableDictionary *)currentUser
{
    NSArray *users = [NSArray arrayWithContentsOfFile:[self userFilePath]];
    for (NSDictionary *user in users) {
        if ([[user objectForKey:@"default"] boolValue] == YES) {
            return [NSMutableDictionary dictionaryWithDictionary:user];
        }
    }
    return [NSMutableDictionary dictionaryWithDictionary:[users objectAtIndex:0]];
}

- (void)updateRecord:(NSDictionary *)record forUsername:(NSString *)username
{
    NSMutableArray *users = [NSMutableArray arrayWithArray:[self userList]];
    NSDictionary *user;
    NSInteger idx = -1;
    for (NSInteger i = 0; i < [users count]; i++) {
        user = [users objectAtIndex:i];
        if ([[user objectForKey:@"username"] isEqualToString:username]) {
            idx = i;
            break;
        }
    }
    if (idx >= 0) {
        [users replaceObjectAtIndex:idx withObject:record];
        [self saveUserList:users];
    }
}

@end
