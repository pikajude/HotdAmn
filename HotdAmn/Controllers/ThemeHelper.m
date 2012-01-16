//
//  ThemeHelper.m
//  HotdAmn
//
//  Created by Joel on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeHelper.h"

@implementation ThemeHelper

+ (NSArray *)themeList
{
    NSMutableArray *allThemes;
    NSMutableIndexSet *validThemes = [NSMutableIndexSet indexSet];
    NSFileManager *man = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         NO);
    NSString *path = [[[[paths objectAtIndex:0]
               stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]]
               stringByAppendingPathComponent:@"Themes"] stringByExpandingTildeInPath];

    [man createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSError *err;
    NSArray *regularThemes = [man contentsOfDirectoryAtPath:path error:&err];
    NSArray *ourThemes = [man contentsOfDirectoryAtPath:[[NSBundle mainBundle] pathForResource:@"Themes" ofType:@""] error:nil];
    
    allThemes = [NSMutableArray arrayWithArray:regularThemes];
    [allThemes addObjectsFromArray:ourThemes];
    
    for (NSInteger i = 0; i < [allThemes count]; i++) {
        NSArray *children = [man contentsOfDirectoryAtPath:[[[NSBundle mainBundle] pathForResource:@"Themes" ofType:@""] stringByAppendingPathComponent:[allThemes objectAtIndex:i]] error:&err];
        if (!children) {
            NSLog(@"%@", [err localizedDescription]);
            err = nil;
            continue;
        }
        if ([children containsObject:@"index.html"] && [children containsObject:@"style.css"]) {
            [validThemes addIndex:i];
        }
    }
    
    return [allThemes objectsAtIndexes:validThemes];
}

@end
