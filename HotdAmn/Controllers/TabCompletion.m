//
//  TabCompletion.m
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabCompletion.h"
#import "HotDamn.h"

static tabcmp *makeTabcmp(NSString *cont, NSInteger loc) {
    tabcmp *t = malloc(sizeof(tabcmp));
    t->content = cont;
    t->cursorLocation = loc;
    return t;
}

static NSRange getRangeOfSelectedWord(NSString *str, NSInteger loc) {
    NSInteger start = [[str substringToIndex:loc] rangeOfString:@" " options:NSBackwardsSearch].location;
    NSInteger end = [[str substringFromIndex:loc] rangeOfString:@" "].location;
    if (start == NSNotFound)
        start = 0;
    else
        ++start;
    if (end == NSNotFound)
        end = [str length];
    else
        end += loc;
    
    return NSMakeRange(start, end - start);
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
        return [self _completeUsernameString:str
                       withPossibleUsernames:[possibilities sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
                              cursorLocation:location];
    } else {
        NSRange range = getRangeOfSelectedWord(str, location);
        if (range.location == 0) {
            return [self _completeCommandString:str withPossibleCommands:[[Command allCommands] allKeys] cursorLocation:location];
        } else {
            NSInteger commandIndex = -1;
            for (int i = 0; i < range.location; i++) {
                if ([str characterAtIndex:i] == ' ') {
                    commandIndex++;
                }
            }
            
            NSString *commandName = [[[str componentsSeparatedByString:@" "] objectAtIndex:0] substringFromIndex:1];
            Command *argDict = [[Command allCommands] objectForKey:commandName];
            int argType;
            
            if (argDict == nil || [argDict arity] == 0) {
                return makeTabcmp(str, location);
            }
            
            if ([argDict arity] > 0) {
                // positive arity
                if (commandIndex >= [argDict arity]) {
                    return makeTabcmp(str, location);
                } else {
                    argType = [[[argDict types] objectAtIndex:commandIndex] intValue];
                }
            } else {
                // negative arity, so varargs
                NSInteger arity = [argDict arity] * -1 - 1;
                if (commandIndex > arity) {
                    argType = [[[argDict types] lastObject] intValue];
                } else {
                    argType = [[[argDict types] objectAtIndex:commandIndex] intValue];
                }
            }
            
            NSArray *possibleArgs = [self _getPossibleArgs:argType withDetails:details];
            
            return [self _completeCommandArgString:str withPossibleArgs:possibleArgs cursorLocation:location];
        }
    }
}

+ (tabcmp *)_completeUsernameString:(NSString *)str withPossibleUsernames:(NSArray *)names cursorLocation:(NSInteger)location
{
    NSRange range = getRangeOfSelectedWord(str, location);
    NSString *username = [str substringWithRange:range];
    BOOL isEmpty = [username length] == 0;
    NSIndexSet *possibilities = [names indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj lowercaseString] hasPrefix:[username lowercaseString]] || isEmpty;
    }];
    NSArray *matches = [names objectsAtIndexes:possibilities];
    if ([matches count] == 0) {
        return makeTabcmp(str, location);
    }

    NSString *match = [matches objectAtIndex:0];
    
    return makeTabcmp([str stringByReplacingCharactersInRange:range withString:match],
                      range.location + [match length]);
}

+ (tabcmp *)_completeCommandString:(NSString *)str withPossibleCommands:(NSArray *)commandNames cursorLocation:(NSInteger)location
{
    NSRange range = getRangeOfSelectedWord(str, location);
    range.location++;
    range.length--;
    NSString *partialCommand = [str substringWithRange:range];
    BOOL isEmpty = [partialCommand length] == 0;
    
    NSIndexSet *potentialCommandIndexes = [commandNames indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj lowercaseString] hasPrefix:[partialCommand lowercaseString]] || isEmpty;
    }];
    
    if ([potentialCommandIndexes lastIndex] == NSNotFound) {
        return makeTabcmp(str, location);
    }
    
    NSArray *potentialCommands = [commandNames objectsAtIndexes:potentialCommandIndexes];
    NSString *cmd = [potentialCommands objectAtIndex:0];
    
    NSString *firstPiece = [str substringToIndex:range.location - 1];
    NSString *lastPiece = [str substringFromIndex:range.location + range.length];
    
    return makeTabcmp([NSString stringWithFormat:@"/%@%@ %@", firstPiece, cmd, lastPiece],
                      [firstPiece length] + [cmd length] + 2);
}

+ (tabcmp *)_completeCommandArgString:(NSString *)command withPossibleArgs:(NSArray *)args cursorLocation:(NSInteger)location
{
    NSRange range = getRangeOfSelectedWord(command, location);
    NSString *partialArg = [command substringWithRange:range];
    BOOL isEmpty = [partialArg length] == 0;
    
    NSIndexSet *potentialCommandIndexes = [args indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj lowercaseString] hasPrefix:[partialArg lowercaseString]] || isEmpty;
    }];
    
    if ([potentialCommandIndexes lastIndex] == NSNotFound) {
        return makeTabcmp(command, location);
    }
    
    NSString *cmd = [[args objectsAtIndexes:potentialCommandIndexes] objectAtIndex:0];
    
    return makeTabcmp([command stringByReplacingCharactersInRange:range
                                                       withString:cmd],
                      range.location + [cmd length]);
}

+ (NSArray *)_getPossibleArgs:(int)types withDetails:(NSString *)details
{
    NSMutableArray *poss = [NSMutableArray array];
    
    // All privclasses
    if (types & ArgTypePrivclass) {
        NSDictionary *privclasses = [[[(HotDamn *)[[NSApplication sharedApplication] delegate] evtHandler] privclasses] objectForKey:details];
        [poss addObjectsFromArray:[privclasses allKeys]];
    }
    
    // All users
    if (types & ArgTypeUsername) {
        NSArray *userObjects = [[User listForRoom:details] allChildren];
        for (UserListNode *obj in userObjects) {
            [poss addObject:[obj title]];
        }
    }
    
    // All rooms
    if (types & ArgTypeRoom) {
        [poss addObjectsFromArray:[[[(HotDamn *)[[NSApplication sharedApplication] delegate] evtHandler] privclasses] allKeys]];
    }
    
    [poss sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return poss;
}

@end
