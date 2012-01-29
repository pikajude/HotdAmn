//
//  MessageFormatter.h
//  HotdAmn
//
//  Created by Joel on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface MessageFormatter : NSObject

+ (NSString *)formatMessage:(Message *)msg;

@end
