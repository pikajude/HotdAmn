//
//  Command.h
//  HotdAmn
//
//  Created by Joel on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ArgTypeAny,
    ArgTypePrivclass,
    ArgTypeUsername,
    ArgTypeRoom
};

@interface Command : NSObject

+ (NSDictionary *)commands;

@end
