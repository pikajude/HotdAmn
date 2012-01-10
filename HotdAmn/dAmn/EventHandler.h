//
//  EventHandler.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DamnSocket.h"
#import "NSDictionary+User.h"

@protocol EventHandlerDelegate <NSObject>

- (void)postMessage:(NSString *)msg inRoom:(NSString *)roomName;

@end

@class HotDamn;

@interface EventHandler : NSObject <DamnSocketDelegate> {
    DamnSocket *sock;
}

@property (assign) HotDamn *delegate;
@property (assign) NSMutableDictionary *user;

#pragma mark -
#pragma mark Socket delegate methods
- (void)onPacket:(Packet *)msg;
- (void)onServer:(Packet *)msg;
- (void)onLogin:(Packet *)msg;
- (void)onJoin:(Packet *)msg;

#pragma mark -
#pragma mark Actions
- (void)join:(NSString *)roomName;

- (void)startConnection;

@end
