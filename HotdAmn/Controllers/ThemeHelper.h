//
//  ThemeHelper.h
//  HotdAmn
//
//  Created by Joel on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeHelper : NSObject

+ (NSArray *)themePathList;
+ (NSArray *)themeList;
+ (NSString *)pathForThemeStylesheet:(NSString *)themeName;
+ (NSString *)contentsOfThemeStylesheet:(NSString *)themeName;
+ (NSString *)pathForThemeTemplate:(NSString *)themeName;
+ (NSString *)contentsOfThemeTemplate:(NSString *)themeName;

@end
