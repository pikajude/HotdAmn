//
//  EventHandler.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DamnSocket.h"

@class HotDamn;

@interface EventHandler : NSObject <DamnSocketDelegate> {
    DamnSocket *sock;
}

@property (assign) HotDamn *delegate;
@property (assign) NSString *username;
@property (assign) NSString *token;

- (void)onPacket:(Packet *)msg;
- (void)onServer:(Packet *)msg;

- (void)startConnection;

@end
