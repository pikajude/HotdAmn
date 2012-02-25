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
#import "ErrorMessage.h"
#import "WhoisMessage.h"
#import "WConnection.h"
#import "UserAction.h"
#import "NSDictionary+User.h"
#import "NSMutableDictionary+Privclass.h"
#import "UserManager.h"
#import "GTMNSString+HTML.h"

@protocol EventHandlerDelegate <NSObject>

- (void)postMessage:(Message *)msg inRoom:(NSString *)roomName;

@end

@class HotDamn;

@interface EventHandler : NSObject <DamnSocketDelegate> {
    DamnSocket *sock;
    BOOL disconnecting;
    BOOL loggedIn;
    NSMutableArray *roomBuffer;
}

@property (readonly) NSMutableDictionary *privclasses;
@property (assign) HotDamn *delegate;
@property (retain) NSMutableDictionary *user;

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
- (void)onRecvAction:(Packet *)msg;
- (void)onSet:(Packet *)msg;
- (void)onWhois:(Packet *)msg;
- (void)onError:(Packet *)msg;

#pragma mark -
#pragma mark Actions
- (void)join:(NSString *)room;
- (void)part:(NSString *)room;
- (void)say:(NSString *)line inRoom:(NSString *)room;
- (void)sayUnparsed:(NSString *)str inRoom:(NSString *)room;
- (void)action:(NSString *)line inRoom:(NSString *)room;
- (void)kick:(NSString *)user fromRoom:(NSString *)room;
- (void)kick:(NSString *)user fromRoom:(NSString *)room withReason:(NSString *)reason;
- (void)setTopic:(NSString *)topic inRoom:(NSString *)room;
- (void)whois:(NSString *)username;

- (void)onLaunch;

- (void)startConnection;
- (void)stopConnection;

@end
