//
//  UserListNode.h
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserListNode : NSObject

@property (retain) User *object;
@property (retain) NSString *title;
@property (readonly) NSMutableArray *children;
@property (assign) BOOL isLeaf;
@property (assign) NSInteger joinCount;

- (void)addChildren:(NSArray *)objects;
- (void)addChild:(id)obj;
- (void)removeChildWithTitle:(NSString *)title;
- (UserListNode *)childWithTitle:(NSString *)title;
- (void)sortChildrenWithComparator:(NSComparator)cmptr;
- (NSArray *)allChildren;

@end
