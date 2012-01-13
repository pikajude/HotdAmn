//
//  Message.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserManager.h"

@interface Message : NSObject

@property (readonly) BOOL highlight;
@property (readonly) NSString *content;
@property (readonly) NSDate *date;

- (id)initWithContent:(NSString *)cont;

@end
