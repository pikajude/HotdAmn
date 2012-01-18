//
//  EventHandler.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DamnSocket.h"
#import "Message.h"
#import "UserMessage.h"
#import "NSDictionary+User.h"
#import "NSMutableDictionary+Privclass.h"

@protocol EventHandlerDelegate <NSObject>

- (void)postMessage:(Message *)msg inRoom:(NSString *)roomName;

@end

@class HotDamn;

@interface EventHandler : NSObject <DamnSocketDelegate> {
    DamnSocket *sock;
    NSMutableDictionary *privclasses;
}

@property (assign) HotDamn *delegate;
@property (assign) NSMutableDictionary *user;

#pragma mark -
#pragma mark Socket delegate methods
- (void)onPacket:(Packet *)msg;
- (void)onServer:(Packet *)msg;
- (void)onPing:(Packet *)msg;
- (void)onLogin:(Packet *)msg;
- (void)onJoin:(Packet *)msg;
- (void)onPropertyMembers:(Packet *)msg;
- (void)onPropertyPrivclasses:(Packet *)msg;
- (void)onPropertyTopic:(Packet *)msg;
- (void)onRecvJoin:(Packet *)msg;
- (void)onRecvPart:(Packet *)msg;
- (void)onRecvMsg:(Packet *)msg;

#pragma mark -
#pragma mark Actions
- (void)join:(NSString *)roomName;
- (void)onLaunch;

- (void)startConnection;
- (void)stopConnection;

@end
