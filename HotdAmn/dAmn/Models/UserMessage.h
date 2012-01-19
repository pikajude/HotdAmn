//
//  UserMessage.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"
#import "User.h"

@interface UserMessage : Message

@property (readonly) User *user;
@property (readwrite) BOOL highlight;

- (UserMessage *)initWithContent:(NSString *)content user:(User *)usr;

@end
