//
//  WhoisMessage.h
//  HotdAmn
//
//  Created by Joel on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"
#import "WConnection.h"
#import "AvatarManager.h"

@class MessageFormatter;

@interface WhoisMessage : Message {
    NSMutableArray *connections;
}

@property (retain) NSString *username;
@property (retain) NSDictionary *metadata;

- (void)addConnection:(WConnection *)conn;

- (NSString *)asHTML;

@end
