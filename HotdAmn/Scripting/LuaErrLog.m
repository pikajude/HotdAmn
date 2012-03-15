//
//  LuaErrLog.m
//  HotdAmn
//
//  Created by Joel on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuaErrLog.h"

static NSMutableArray *errs = NULL;

@implementation LuaErrLog

@synthesize location, line, error;

- (id)initWithError:(NSError *)err
{
    self = [super init];
    NSString *msg = [err localizedDescription];
    NSScanner *scanner = [NSScanner scannerWithString:msg];
    [scanner scanUpToString:@":" intoString:&location];
    location = [location lastPathComponent];
    [scanner scanString:@":" intoString:nil];
    [scanner scanInteger:&line];
    [scanner scanString:@":" intoString:nil];
    error = [[scanner string] substringFromIndex:[scanner scanLocation]];
    [location retain];
    [error retain];
    return self;
}

+ (void)logError:(NSError *)err
{
    if (errs == NULL)
        errs = [[NSMutableArray array] retain];
    if (err == NULL)
        return;
    [errs addObject:[[[LuaErrLog alloc] initWithError:err] autorelease]];
    NSNotification *not = [NSNotification notificationWithName:@"luaerr"
                                                        object:nil
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:[errs lastObject]
                                                                              forKey:@"err"]];
    [[NSNotificationCenter defaultCenter] postNotification:not];
}

+ (NSArray *)log
{
    return errs;
}

+ (void)clear
{
    [errs release];
    errs = [[NSMutableArray array] retain];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%ld: %@", location, line, error];
}

- (void)dealloc
{
    [location release];
    [error release];
    [super dealloc];
}

@end
