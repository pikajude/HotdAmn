//
//  Socket.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Packet.h"

@protocol DamnSocketDelegate <NSObject>

- (void)onPacket:(Packet *)msg;
- (void)onServer:(Packet *)msg;
- (void)onLogin:(Packet *)msg;
- (void)onJoin:(Packet *)msg;
- (void)onPart:(Packet *)msg;
- (void)onPropertyMembers:(Packet *)msg;
- (void)onPropertyPrivclasses:(Packet *)msg;
- (void)onPropertyTopic:(Packet *)msg;
/*- (void)onProperty:(Packet *)msg;
- (void)onRecvMsg:(Packet *)msg;
- (void)onRecvAction:(Packet *)msg;
- (void)onRecvJoin:(Packet *)msg;
- (void)onRecvPart:(Packet *)msg;
- (void)onRecvPrivchg:(Packet *)msg;
- (void)onRecvKicked:(Packet *)msg;
- (void)onRecvAdmin:(Packet *)msg;
- (void)onKicked:(Packet *)msg;
- (void)onPing:(Packet *)msg;
- (void)onDisconnect:(Packet *)msg;
- (void)onError:(Packet *)msg;
 */

@end

@interface DamnSocket : NSObject <NSStreamDelegate> {
    NSInputStream  *istream;
    NSOutputStream *ostream;
    NSHost         *host;
    NSDictionary   *events;
    
    NSMutableData *buf;
}

@property (assign) id <DamnSocketDelegate> delegate;

- (void)handleInputStreamEvent:(NSStreamEvent)eventCode;
- (void)handleOutputStreamEvent:(NSStreamEvent)eventCode;

- (void)open;
- (void)write:(NSString *)str;

- (NSString *)eventName:(Packet *)pkt;

@end
