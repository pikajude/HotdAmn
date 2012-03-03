//
//  LuaErrLog.h
//  HotdAmn
//
//  Created by Joel on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaErrLog : NSObject {
    NSString *location;
    NSInteger line;
    NSString *error;
}

@property (readonly) NSString *location;
@property (readonly) NSInteger line;
@property (readonly) NSString *error;

- (id)initWithError:(NSError *)err;

+ (void)logError:(NSError *)err;
+ (NSArray *)log;

- (NSAttributedString *)attributedDescription;

@end
