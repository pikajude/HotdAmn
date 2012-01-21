//
//  TabCompletion.h
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "UserListNode.h"
#import "User.h"

typedef struct {
    NSString *content;
    NSInteger cursorLocation;
} tabcmp;

static tabcmp *makeTabcmp(NSString *cont, NSInteger loc);
static NSRange getRangeOfSelectedWord(NSString *str, NSInteger loc);

@class HotDamn;

@interface TabCompletion : NSObject

+ (tabcmp *)completePartialString:(NSString *)str details:(NSString *)details cursorLocation:(NSInteger)location;

@end

@interface TabCompletion ()

+ (tabcmp *)_completeUsernameString:(NSString *)str withPossibleUsernames:(NSArray *)names cursorLocation:(NSInteger)location;
+ (tabcmp *)_completeCommandString:(NSString *)str withPossibleCommands:(NSArray *)command cursorLocation:(NSInteger)location;
+ (tabcmp *)_completeCommandArgString:(NSString *)command withPossibleArgs:(NSArray *)args cursorLocation:(NSInteger)location;
+ (NSArray *)_getPossibleArgs:(int)types withDetails:(NSString *)details;

@end
