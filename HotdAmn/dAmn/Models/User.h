//
//  User.h
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarManager.h"

@interface User : NSObject

- (User *)initWithUsername:(NSString *)username userIcon:(NSInteger)userIcon symbol:(char)symbol;

@property (readonly) NSString *username;
@property (readonly) NSInteger usericon;
@property (readonly) char symbol;
@property (assign) NSImage *avatar;

- (NSImage *)avatar;

@end
