//
//  Token.h
//  HotdAmn
//
//  Created by Joel on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Security/Security.h>
#include <CoreServices/CoreServices.h>
#import "JSONKit.h"

@interface Token : NSObject

+ (void)storeCode:(NSString *)token forUsername:(NSString *)username;
+ (NSString *)getCodeForUsername:(NSString *)username;
+ (NSString *)getUsernameForAccessToken:(NSString *)access;
+ (NSString *)getAccessTokenForCode:(NSString *)code refresh:(BOOL)ref;
+ (NSString *)getDamnTokenForAccessToken:(NSString *)access;

@end
