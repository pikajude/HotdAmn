//
//  Token.m
//  HotdAmn
//
//  Created by Joel on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Token.h"

static char *servName = "deviantART OAuth";
static UInt32 servNameLength = 16;

@implementation Token

+ (void)storeToken:(NSString *)token forUsername:(NSString *)username
{
    if ([self getTokenForUsername:username] == NULL) { // Token not already stored.
        SecKeychainAddGenericPassword(NULL,
                                      servNameLength,
                                      servName,
                                      (UInt32)[username length],
                                      [username UTF8String],
                                      (UInt32)[token length],
                                      [token UTF8String],
                                      NULL);
    } else { // We're about to modify the token.
        SecKeychainItemRef ref = NULL;
        SecKeychainFindGenericPassword(NULL, servNameLength, servName, (UInt32)[username length], [username UTF8String], NULL, NULL, &ref);
        
        SecKeychainItemModifyAttributesAndData(ref,
                                               NULL,
                                               (UInt32)[token length],
                                               [token UTF8String]);
        
        CFRelease(ref);
    }
}

+ (NSString *)getTokenForUsername:(NSString *)username
{
    UInt32 len;
    char *tok = malloc(sizeof(char[32]));
    OSStatus stat = SecKeychainFindGenericPassword(NULL,
                                                   servNameLength,
                                                   servName,
                                                   (UInt32)[username length],
                                                   [username UTF8String],
                                                   &len,
                                                   (void **)&tok,
                                                   NULL);
    
    if (stat == errSecItemNotFound) {
        free(tok);
        return NULL;
    }
    
    tok[len] = '\0';
    NSString *str = [[[NSString alloc] initWithCString:tok encoding:NSUTF8StringEncoding] autorelease];
    free(tok);
    
    return str;
}

@end
