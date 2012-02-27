//
//  Topic.m
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"
#import "Chat.h"

static NSMutableArray *watchers;
static NSMutableDictionary *topics;
static NSMutableDictionary *titles;

@implementation Topic

+ (void)setTopic:(NSString *)topic forRoom:(NSString *)roomName
{
    if (!topics)
        topics = [[NSMutableDictionary dictionary] retain];
    [topics setObject:topic forKey:roomName];
    for (NSValue *obj in watchers) {
        if ([(id)[obj pointerValue] respondsToSelector:@selector(onTopicChange)])
            [(id<TopicWatcher>)[obj pointerValue] onTopicChange];
    }
}

+ (void)setTitle:(NSString *)title forRoom:(NSString *)roomName
{
    if (!titles)
        titles = [[NSMutableDictionary dictionary] retain];
    [titles setObject:title forKey:roomName];
    for (NSValue *obj in watchers) {
        if ([(id)[obj pointerValue] respondsToSelector:@selector(onTitleChange)])
            [(id<TopicWatcher>)[obj pointerValue] onTitleChange];
    }
}

+ (NSString *)topicForRoom:(NSString *)roomName
{
    return [topics objectForKey:roomName];
}

+ (NSString *)titleForRoom:(NSString *)roomName
{
    return [titles objectForKey:roomName];
}

+ (void)removeRoom:(NSString *)room
{
    [topics removeObjectForKey:room];
    [titles removeObjectForKey:room];
}

+ (void)addWatcher:(id<TopicWatcher>)watcher
{
    if (!watchers)
        watchers = [[NSMutableArray array] retain];
    [watchers addObject:[NSValue valueWithPointer:watcher]];
}

+ (void)removeWatcher:(id<TopicWatcher>)watcher
{
    for (int i = 0; i < [watchers count]; i++) {
        if (watcher == [[watchers objectAtIndex:i] pointerValue]) {
            [self removeRoom:[(Chat *)watcher roomName]];
            [watchers removeObjectAtIndex:i];
            return;
        }
    }
}

@end
