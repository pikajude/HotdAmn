//
//  Packet.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Packet : NSObject

@property (readonly) NSString *command;
@property (readonly) NSString *param;
@property (readonly) NSDictionary *args;
@property (readonly) NSString *body;
@property (readonly) NSString *raw;

- (Packet *)subpacket;
- (Packet *)initWithString:(NSString *)str;

- (NSString *)roomName;
- (NSString *)roomWithOctothorpe;

- (BOOL)isOkay;

@end
