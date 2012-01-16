//
//  Message.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserManager.h"
#import "User.h"

@interface Message : NSObject

@property (readonly) NSString *content;
@property (readonly) NSDate *date;

- (id)initWithContent:(NSString *)cont;
- (NSString *)cssClasses;

#pragma mark -
#pragma mark Dummy methods
- (User *)user;
- (BOOL)highlight;

@end
