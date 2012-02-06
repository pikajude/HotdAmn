//
//  Topic.h
//  HotdAmn
//
//  Created by Joel on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class HotDamn;

@interface TopicDialog : NSWindowController <NSTextViewDelegate> {
    IBOutlet NSTextView *topicContents;
    IBOutlet WebView *topicRendered;
    NSString *_roomName;
    NSString *_contents;
}

@property (assign) id delegate;

- (TopicDialog *)initWithContents:(NSString *)contents roomName:(NSString *)roomName;

- (IBAction)updateTopic:(id)sender;
- (IBAction)end:(id)sender;

- (void)textDidChange:(NSNotification *)notification;

@end
