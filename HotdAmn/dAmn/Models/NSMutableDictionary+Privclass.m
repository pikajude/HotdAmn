//
//  NSMutableDictionary+Privclass.m
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableDictionary+Privclass.h"

@implementation NSMutableDictionary (Privclass)

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)addPrivclass:(NSString *)className withLevel:(NSInteger)level
{
    [self setObject:[NSNumber numberWithInteger:level] forKey:className];
}

- (NSInteger)levelForPrivclass:(NSString *)className {
    return [[self objectForKey:className] integerValue];
}

@end
