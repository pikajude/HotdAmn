//
//  Chat.h
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "ChatView.h"

@interface Chat : NSViewController <NSSplitViewDelegate>

@property (assign) id delegate;

@property (assign) IBOutlet NSSplitView *split;
@property (assign) IBOutlet WebView *chatView;
@property (assign) IBOutlet ChatView *chatParent;
@property (assign) IBOutlet NSView *userView;
@property (assign) IBOutlet NSView *chatContainer;
@property (assign) IBOutlet NSTextField *input;

- (void)selectInput;

@end
