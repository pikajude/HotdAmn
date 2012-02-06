//
//  TopicDialog.m
//  HotdAmn
//
//  Created by Joel on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicDialog.h"
#import "HotDamn.h"

@implementation TopicDialog

@synthesize delegate;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setTitle:_roomName];
    [topicContents setString:_contents];
    [[topicRendered mainFrame] loadHTMLString:_contents baseURL:[NSURL URLWithString:@"http://www.deviantart.com"]];
    [topicContainer setBorderColor:[NSColor colorWithDeviceWhite:0.74f alpha:1.0f]];
}

- (TopicDialog *)initWithContents:(NSString *)contents roomName:(NSString *)roomName
{
    self = [super initWithWindowNibName:@"Topic"];
    _roomName = [roomName retain];
    _contents = [contents retain];
    return self;
}

- (IBAction)updateTopic:(id)sender
{
    [[[self delegate] evtHandler] setTopic:[[topicContents textStorage] string]
                                    inRoom:_roomName];
    [self end:nil];
}

- (IBAction)end:(id)sender
{
    [NSApp endSheet:[self window]];
    [[self window] orderOut:nil];
}

- (void)textDidChange:(NSNotification *)notification
{
    [[topicRendered mainFrame] loadHTMLString:[[topicContents textStorage] string]
                                      baseURL:[NSURL URLWithString:@"http://www.deviantart.com"]];
}

- (void)dealloc
{
    [_roomName release];
    [_contents release];
    [super dealloc];
}

@end
