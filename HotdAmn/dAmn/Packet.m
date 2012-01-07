//
//  Packet.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Packet.h"

@implementation Packet

@synthesize body, args, command, param;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (Packet *)initWithString:(NSString *)str
{
    self = [super init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *key = [[[NSString alloc] init] autorelease];
    NSString *val = [[[NSString alloc] init] autorelease];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    // Scan command section
    [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&command];
    
    // If there's no space after a command, we have a command-only packet
    if (![scanner scanString:@" " intoString:nil]) {
        return self;
    }
    
    // Scan param section
    [scanner scanCharactersFromSet:[[NSCharacterSet characterSetWithCharactersInString:@" \n\t"] invertedSet]
                        intoString:&param];
    
    if ([scanner scanString:@"\n\n" intoString:nil]) {
        // Double newline, everything after here is the body
        body = [str substringFromIndex:[scanner scanLocation]];
        return self;
    }
    
    if (![scanner scanString:@"\n" intoString:nil]) {
        // Not even a single newline, end of packet
        return self;
    }
    
    // Parsing an argument list
    while (true) {
        if (![scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] 
                                 intoString:&key]) {
            break;
        }
        [scanner scanString:@"=" intoString:nil];
        [scanner scanCharactersFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"\n"] invertedSet]
                 intoString:&val];
        
        [dict setObject:val forKey:key];
        
        [scanner scanString:@"\n" intoString:nil];
    }
    
    args = (NSDictionary *)dict;
    
    if ([scanner scanString:@"\n" intoString:nil])
        body = [str substringFromIndex:[scanner scanLocation]];
    
    return self;
}

- (Packet *)subpacket
{
    if (body == NULL)
        return NULL;
    
    return [[[Packet alloc] initWithString:body] autorelease];
}

@end
