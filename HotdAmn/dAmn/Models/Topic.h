//
//  Topic.h
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TopicWatcher <NSObject>

- (void)onTopicChange;

@optional
- (void)onTitleChange;

@end

@class Chat;

@interface Topic : NSObject {
    NSArray *watchers;
}

+ (void)setTopic:(NSString *)topic forRoom:(NSString *)roomName;
+ (void)setTitle:(NSString *)title forRoom:(NSString *)roomName;
+ (NSString *)topicForRoom:(NSString *)roomName;
+ (NSString *)titleForRoom:(NSString *)roomName;
+ (void)removeRoom:(NSString *)room;
+ (void)addWatcher:(id<TopicWatcher>)watcher;
+ (void)removeWatcher:(id<TopicWatcher>)watcher;

@end
