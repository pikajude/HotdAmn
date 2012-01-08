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

+ (void)storeCode:(NSString *)token forUsername:(NSString *)username
{
    if ([self getCodeForUsername:username] == NULL) { // Token not already stored.
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

+ (NSString *)getCodeForUsername:(NSString *)username
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

+ (NSString *)getUsernameForAccessToken:(NSString *)access
{
    NSString *url = [NSString stringWithFormat:@"https://www.deviantart.com/api/draft15/user/whoami?access_token=%@", access];
    NSData *dat = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:nil error:nil];
    NSDictionary *resp = [[JSONDecoder decoder] objectWithData:dat];
    return [resp objectForKey:@"username"];
}

+ (NSString *)getNewAccessTokenForUsername:(NSString *)username
{
    NSString *code = [Token getCodeForUsername:username];
    return [Token getAccessTokenForCode:code refresh:YES];
}

+ (NSString *)getAccessTokenForCode:(NSString *)code refresh:(BOOL)ref
{
    NSString *qstring;
    if (ref) {
        qstring = [NSString stringWithFormat:@"refresh_token=%@&grant_type=refresh_token", code];
    } else {
        qstring = [NSString stringWithFormat:@"code=%@&grant_type=authorization_code", code];
    }
    NSString *url = [NSString stringWithFormat:@"https://www.deviantart.com/oauth2/draft15/token?client_id=121&client_secret=1b533761582f17a1f5c094d14054af92&%@", qstring];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLResponse *resp;
    
    NSData *dat = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:nil];
    
    NSDictionary *obj = [[JSONDecoder decoder] objectWithData:dat];
    
    [Token storeCode:[obj objectForKey:@"refresh_token"] forUsername:[Token getUsernameForAccessToken:[obj objectForKey:@"access_token"]]];
    
    return [obj objectForKey:@"access_token"];
}

+ (NSString *)getDamnTokenForAccessToken:(NSString *)access
{
    NSString *url = [NSString stringWithFormat:@"https://www.deviantart.com/api/draft15/user/damntoken?access_token=%@", access];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData *dat = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    
    NSDictionary *resp = [[JSONDecoder decoder] objectWithData:dat];
    
    return [resp objectForKey:@"damntoken"];
}

@end
