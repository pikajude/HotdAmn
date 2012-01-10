//
//  NSDictionary+User.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+User.h"

@implementation NSMutableDictionary (User)

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)refreshFields
{
    // New refresh code
    [self setValue:[Token getCodeForUsername:[self objectForKey:@"username"]] forKey:@"refreshcode"];
    
    // New access token
    NSString *newAccessToken = [Token getAccessTokenForCode:[self objectForKey:@"refreshcode"] refresh:YES];
    [self setValue:newAccessToken forKey:@"accesstoken"];
    
    // New authtoken
    NSString *newAuthtoken = [Token getDamnTokenForAccessToken:newAccessToken];
    [self setValue:newAuthtoken forKey:@"authtoken"];
}

@end
