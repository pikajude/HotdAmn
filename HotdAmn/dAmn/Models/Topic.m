//
//  Topic.m
//  HotdAmn
//
//  Created by Joel on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"

static NSMutableArray *watchers;
static NSMutableDictionary *topics;

@implementation Topic

+ (void)setTopic:(NSString *)topic forRoom:(NSString *)roomName
{
    if (!topics)
        topics = [[NSMutableDictionary dictionary] retain];
    [topics setObject:topic forKey:roomName];
    for (id obj in watchers) {
        [obj onTopicChange];
    }
}

+ (NSString *)topicForRoom:(NSString *)roomName
{
    return [topics objectForKey:roomName];
}

+ (void)removeRoom:(NSString *)room
{
    [topics removeObjectForKey:room];
}

+ (void)addWatcher:(id<TopicWatcher>)watcher
{
    if (!watchers)
        watchers = [[NSMutableArray array] retain];
    [watchers addObject:watcher];
}

+ (void)removeWatcher:(id<TopicWatcher>)watcher
{
    [watchers removeObject:watcher];
}

@end
