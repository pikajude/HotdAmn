//
//  Packet.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tablumps.h"
#import "UserManager.h"

@interface Packet : NSObject

@property (readonly) NSString *command;
@property (readonly) NSString *param;
@property (readonly) NSDictionary *args;
@property (readonly) NSString *body;
@property (readonly) NSString *raw;

- (Packet *)subpacket;
- (Packet *)initWithString:(NSString *)str;

- (NSString *)roomName;

- (BOOL)isOkay;
- (BOOL)isPchat;

@end
