//
//  Socket.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NSPacket NSString

@protocol DamnConnectionDelegate <NSObject>

- (void)onPacket:(NSPacket *)msg;
- (void)onServer:(NSPacket *)msg;
- (void)onLogin:(NSPacket *)msg;
- (void)onJoin:(NSPacket *)msg;
- (void)onPart:(NSPacket *)msg;
- (void)onProperty:(NSPacket *)msg;
- (void)onRecvMsg:(NSPacket *)msg;
- (void)onRecvAction:(NSPacket *)msg;
- (void)onRecvJoin:(NSPacket *)msg;
- (void)onRecvPart:(NSPacket *)msg;
- (void)onRecvPrivchg:(NSPacket *)msg;
- (void)onRecvKicked:(NSPacket *)msg;
- (void)onRecvAdmin:(NSPacket *)msg;
- (void)onKicked:(NSPacket *)msg;
- (void)onPing:(NSPacket *)msg;
- (void)onDisconnect:(NSPacket *)msg;
- (void)onError:(NSPacket *)msg;

@end

@interface Socket : NSObject <NSStreamDelegate> {
    NSInputStream  *istream;
    NSOutputStream *ostream;
    NSHost         *host;
}

- (void)handleInputStreamEvent:(NSStreamEvent)eventCode;
- (void)handleOutputStreamEvent:(NSStreamEvent)eventCode;

- (void)open;
- (void)write:(NSString *)str;

@end
