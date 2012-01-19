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

@interface Message : NSObject {
    BOOL highlight;
}

@property (readonly) NSString *content;
@property (readonly) NSDate *date;

- (id)initWithContent:(NSString *)cont;
- (NSString *)cssClasses;
- (NSString *)asHTML;
- (NSString *)asText;
- (NSString *)timestamp;

- (void)setHighlight:(BOOL)h;
- (BOOL)highlight;

#pragma mark -
#pragma mark Dummy methods
- (User *)user;

@end
