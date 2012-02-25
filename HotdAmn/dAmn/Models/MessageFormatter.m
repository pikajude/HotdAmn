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
    if ([msg respondsToSelector:@selector(asHTML)]) return [(id)msg asHTML];
         
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
    
    [mod replaceOccurrencesOfString:@"\\"
                         withString:@"\\\\"
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [mod length])];
    
    [mod replaceOccurrencesOfString:@"\""
                         withString:@"\\\""
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [mod length])];
    
    return mod;
}

static NSString *pluralize(NSInteger value, NSString *singular) {
    if (value == 1) {
        return [NSString stringWithFormat:@"1 %@", singular];
    } else {
        return [NSString stringWithFormat:@"%ld %@s", value, singular];
    }
}

+ (NSString *)dateDifferenceToString:(NSTimeInterval)startTime
{
    NSInteger days, hours, minutes, seconds;
    NSMutableArray *crud = [NSMutableArray array];
    days = startTime / 86400;
    startTime -= days * 86400;
    hours = startTime / 3600;
    startTime -= hours * 3600;
    minutes = startTime / 60;
    startTime -= minutes * 60;
    seconds = startTime;
    if (days > 0)
        [crud addObject:pluralize(days, @"day")];
    if (hours > 0)
        [crud addObject:pluralize(hours, @"hour")];
    if (minutes > 0)
        [crud addObject:pluralize(minutes, @"minute")];
    if (seconds > 0)
        [crud addObject:pluralize(seconds, @"second")];
    return [crud componentsJoinedByString:@", "];
}

@end
