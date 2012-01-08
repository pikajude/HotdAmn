//
//  Welcome.h
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "OAuthLocalServer.h"
#import "Token.h"

@class UserManager;

@interface Welcome : NSWindowController {
    NSProgressIndicator *spinner;
    BOOL connection;
}

@property (assign) IBOutlet NSImageView *icon;
@property (assign) IBOutlet NSTextField *welcomeMsg;
@property (assign) IBOutlet NSWindow *webWindow;
@property (assign) IBOutlet WebView *webView;

@property (assign) id delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)getStarted:(id)sender;

- (void)receiveIncomingConnection:(NSNotification *)object;

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;

- (void)loadFailed:(id)sender;

@end
