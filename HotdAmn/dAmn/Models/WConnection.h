//
//  WConnection.h
//  HotdAmn
//
//  Created by Joel on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WConnection : NSObject {
    NSMutableArray *rooms;
}

@property (assign) NSInteger connectionTime;
@property (assign) NSInteger idleTime;

- (void)addRoom:(NSString *)room;
- (NSArray *)rooms;

@end