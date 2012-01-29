//
//  ServerChat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerChat.h"

@implementation ServerChat

@synthesize roomName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil roomName:(NSString *)name
{
    self = [super initWithNibName:@"ServerView" bundle:nibBundleOrNil];
    if (self) {
        roomName = name;
    }
    
    return self;
}

- (void)selectInput
{
    return;
}

- (NSSplitView *)split
{
    return nil;
}

- (void)onTopicChange
{
    NSString *title = [NSString stringWithFormat:@"%@ dAmn Server",
                       [[UserManager defaultManager] currentUsername]];
    [[[self view] window] setTitle:title];
}

@end
