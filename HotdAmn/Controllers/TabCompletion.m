//
//  TabCompletion.m
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabCompletion.h"

static tabcmp *makeTabcmp(NSString *cont, NSInteger loc) {
    tabcmp *t = malloc(sizeof(tabcmp));
    t->content = cont;
    t->cursorLocation = loc;
    return t;
}

@implementation TabCompletion

+ (tabcmp *)completePartialString:(NSString *)str details:(NSString *)details cursorLocation:(NSInteger)location
{
    if (![str hasPrefix:@"/"]) {
        // usernames
        NSMutableArray *possibilities = [NSMutableArray array];
        NSArray *userObjects = [[User listForRoom:details] allChildren];
        for (UserListNode *obj in userObjects) {
            [possibilities addObject:[obj title]];
        }
        return [self _completeUsernameString:str withPossibleUsernames:possibilities cursorLocation:location];
    } else {
        return makeTabcmp(str, location);
    }
}

+ (tabcmp *)_completeUsernameString:(NSString *)str withPossibleUsernames:(NSArray *)names cursorLocation:(NSInteger)location
{
    NSInteger start = [[str substringToIndex:location] rangeOfString:@" " options:NSBackwardsSearch].location + 1;
    NSInteger end = [[str substringFromIndex:location] rangeOfString:@" "].location;
    if (start == NSNotFound + 1)
        start = 0;
    if (end == NSNotFound)
        end = [str length];
    else
        end += location;
    
    NSString *username = [str substringWithRange:NSMakeRange(start, end - start)];
    NSIndexSet *possibilities = [names indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj lowercaseString] hasPrefix:[username lowercaseString]];
    }];
    NSArray *matches = [[names objectsAtIndexes:possibilities] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if ([matches count] == 0) {
        return makeTabcmp(str, location);
    }

    NSString *firstPiece = [str substringToIndex:start];
    NSString *lastPiece = [str substringFromIndex:end];
    NSString *match = [matches objectAtIndex:0];
    
    return makeTabcmp([NSString stringWithFormat:@"%@%@%@", firstPiece, match, lastPiece],
                      [firstPiece length] + [match length]);
}

@end
