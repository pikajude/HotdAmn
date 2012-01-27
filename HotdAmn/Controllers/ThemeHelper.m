//
//  ThemeHelper.m
//  HotdAmn
//
//  Created by Joel on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
    NSArray *regularThemes = [[man contentsOfDirectoryAtPath:path error:&err] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.css'"]];;
    NSArray *ourThemes = [[NSBundle mainBundle] pathsForResourcesOfType:@"css" inDirectory:@"Themes"];
    [allThemes addObjectsFromArray:regularThemes];
    [allThemes addObjectsFromArray:ourThemes];
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
    return [pathList objectAtIndex:idx];
}

+ (NSString *)contentsOfThemeStylesheet:(NSString *)themeName
{
    if ([self pathForThemeStylesheet:themeName] == nil) {
        return nil;
    }
    return [[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[self pathForThemeStylesheet:themeName]] encoding:NSUTF8StringEncoding] autorelease];
}

@end
