//
//  MessageFormatter.m
//  HotdAmn
//
//  Created by Joel on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageFormatter.h"
#import "Message.h"
#import "AvatarManager.h"

@implementation MessageFormatter

+ (NSString *)formatMessage:(Message *)msg
{
    NSString *templ = [ThemeHelper contentsOfThemeTemplate:[[NSUserDefaults standardUserDefaults] objectForKey:@"themeName"]];
    
    NSMutableString *mod = [NSMutableString stringWithString:templ];
    
    if ([mod rangeOfString:@"%username%"].location != NSNotFound) {
        [mod replaceOccurrencesOfString:@"%username%"
                             withString:([msg user] == nil ? @"" : [[msg user] username])
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [mod length])];
    }
    
    if ([mod rangeOfString:@"%timestamp%"].location != NSNotFound) {
        [mod replaceOccurrencesOfString:@"%timestamp%"
                             withString:[msg timestamp]
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [mod length])];
    }
    
    if ([mod rangeOfString:@"%avatar%"].location != NSNotFound) {
        [mod replaceOccurrencesOfString:@"%avatar%"
                             withString:([msg user] == nil ? @"" :
                                         [AvatarManager avatarURLForUsername:[[msg user] username]
                                                                    userIcon:[[msg user] usericon]])
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [mod length])];
    }
    
    if ([mod rangeOfString:@"%msg%"].location != NSNotFound) {
        [mod replaceOccurrencesOfString:@"%msg%"
                             withString:[msg content]
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [mod length])];
    }
    
    [mod insertString:[NSString stringWithFormat:@"<li class='%@'>", [msg cssClasses]]
              atIndex:0];
    
    [mod appendString:@"</li>"];
    
    [mod replaceOccurrencesOfString:@"\n"
                         withString:@""
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [mod length])];
    
    [mod replaceOccurrencesOfString:@"\""
                         withString:@"\\\""
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [mod length])];
    
    return mod;
}

@end
