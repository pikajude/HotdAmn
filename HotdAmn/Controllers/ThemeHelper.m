//
//  ThemeHelper.m
//  HotdAmn
//
//  Created by Joel on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define TEMPLATE @"html"
#define STYLESHEET @"css"

#import "ThemeHelper.h"

@implementation ThemeHelper

+ (NSArray *)themePathList
{
    NSMutableArray *allThemes = [NSMutableArray array];
    NSFileManager *man = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         NO);
    NSString *path = [[[[paths objectAtIndex:0]
                        stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]]
                       stringByAppendingPathComponent:@"Themes"] stringByExpandingTildeInPath];
    
    [man createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSError *err;
    NSArray *regularThemes = [[man contentsOfDirectoryAtPath:path error:&err] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.hdtheme'"]];;
    NSArray *ourThemes = [[NSBundle mainBundle] pathsForResourcesOfType:@"hdtheme" inDirectory:@"Themes"];
    [allThemes addObjectsFromArray:regularThemes];
    [allThemes addObjectsFromArray:ourThemes];
    NSMutableIndexSet *bad = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [allThemes count]; i++) {
        NSString *path = [allThemes objectAtIndex:i];
        NSString *themeName = [[path lastPathComponent] stringByDeletingPathExtension];
        NSArray *kids = [man contentsOfDirectoryAtPath:path error:nil];
        if (![kids containsObject:[NSString stringWithFormat:@"%@.%@", themeName, TEMPLATE]] ||
            ![kids containsObject:[NSString stringWithFormat:@"%@.%@", themeName, STYLESHEET]]) {
            [bad addIndex:i];
        }
    }
    [allThemes removeObjectsAtIndexes:bad];
    return allThemes;
}

+ (NSArray *)themeList
{
    NSArray *paths = [self themePathList];
    NSMutableArray *allThemes = [NSMutableArray array];
    for (NSString *str in paths) {
        [allThemes addObject:[[str lastPathComponent] stringByDeletingPathExtension]];
    }

    return allThemes;
}

+ (NSString *)pathForThemeStylesheet:(NSString *)themeName
{
    NSArray *pathList = [self themePathList];
    NSInteger idx = [pathList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[[(NSString *)obj lastPathComponent] stringByDeletingPathExtension] isEqualToString:themeName];
    }];
    if (idx == NSNotFound) {
        return nil;
    }
    return [[pathList objectAtIndex:idx] stringByAppendingFormat:@"/%@.%@", themeName, STYLESHEET];
}

+ (NSString *)contentsOfThemeStylesheet:(NSString *)themeName
{
    static NSString *currentThemeName = nil;
    static NSString *contents = nil;
    if ([self pathForThemeStylesheet:themeName] == nil) {
        return nil;
    }
    if (currentThemeName == nil || currentThemeName != themeName) {
        currentThemeName = themeName;
        if (contents)
            [contents release];
        contents = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[self pathForThemeStylesheet:themeName]] encoding:NSUTF8StringEncoding];
    }
    return contents;
}

+ (NSString *)pathForThemeTemplate:(NSString *)themeName
{
    NSArray *pathList = [self themePathList];
    NSInteger idx = [pathList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[[(NSString *)obj lastPathComponent] stringByDeletingPathExtension] isEqualToString:themeName];
    }];
    if (idx == NSNotFound) {
        return nil;
    }
    return [[pathList objectAtIndex:idx] stringByAppendingFormat:@"/%@.%@", themeName, TEMPLATE];
}

+ (NSString *)contentsOfThemeTemplate:(NSString *)themeName
{
    static NSString *currentThemeName = nil;
    static NSString *contents = nil;
    if ([self pathForThemeTemplate:themeName] == nil) {
        return nil;
    }
    if (currentThemeName == nil || currentThemeName != themeName) {
        currentThemeName = themeName;
        if (contents)
            [contents release];
        contents = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[self pathForThemeTemplate:themeName]] encoding:NSUTF8StringEncoding];
    }
    return contents;
}

@end
