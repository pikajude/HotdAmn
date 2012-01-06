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

@interface Token : NSObject

+ (void)storeToken:(NSString *)token forUsername:(NSString *)username;
+ (NSString *)getTokenForUsername:(NSString *)username;

@end
