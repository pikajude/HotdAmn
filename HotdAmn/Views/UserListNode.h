//
//  UserListNode.h
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListNode : NSObject

@property (assign) NSString *title;
@property (readonly) NSMutableArray *children;
@property (assign) BOOL isLeaf;

- (void)addChildren:(NSArray *)objects;
- (void)addChild:(id)obj;
- (UserListNode *)childWithTitle:(NSString *)title;

@end
