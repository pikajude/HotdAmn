//
//  Welcome.m
//  HotdAmn
//
//  Created by Joel on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Welcome.h"
#import "UserManager.h"

const NSString *url = @"https://www.deviantart.com/oauth2/draft15/authorize?client_id=121&redirect_uri=http://localhost:12345/&response_type=code";

@implementation Welcome

@synthesize icon, welcomeMsg, webWindow, webView, delegate;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        connection = NO;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [icon setImage:[NSApp applicationIconImage]];
}

static NSDictionary *parseQstring(NSString *querystring) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [querystring componentsSeparatedByString:@"&"];
    NSArray *kv;
    for (NSString *pair in pairs) {
        kv = [pair componentsSeparatedByString:@"="];
        [dict setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    return (NSDictionary *)dict;
}

- (void)receiveIncomingConnection:(NSNotification *)not
{
    connection = YES;
    [[webView mainFrame] stopLoading];
    NSFileHandle *hand = [[not userInfo] objectForKey:NSFileHandleNotificationFileHandleItem];
    NSString *reqStart = [[[NSString alloc] initWithData:[hand availableData] encoding:NSUTF8StringEncoding] autorelease];
    NSString *firstLine = [[reqStart componentsSeparatedByString:@"\n"] objectAtIndex:0];
    NSString *qstringSection = [[firstLine componentsSeparatedByString:@" "] objectAtIndex:1];
    NSDictionary *qstring = parseQstring([qstringSection substringFromIndex:2]);
    
    NSString *accessToken = [Token getAccessTokenForCode:[qstring objectForKey:@"code"] refresh:NO];
    NSString *username = [Token getUsernameForAccessToken:accessToken];
    
    [[UserManager defaultManager] addUsername:username refreshCode:[Token getCodeForUsername:username] accessToken:accessToken authToken:[Token getDamnTokenForAccessToken:accessToken]];
    
    [[UserManager defaultManager] finishIntroduction];
}

- (IBAction)getStarted:(id)sender
{
    OAuthLocalServer *serv;
    
    [[self window] orderOut:nil];
    [webWindow center];
    [webWindow makeKeyAndOrderFront:nil];
    
    [webView setFrameLoadDelegate:self];
    
    NSRect frame = [[webView superview] frame];
    spinner = [[[NSProgressIndicator alloc] initWithFrame:NSMakeRect(NSMidX(frame)-16, NSMidY(frame)-16, 32.0f, 32.0f)] autorelease];
    [spinner setStyle:NSProgressIndicatorSpinningStyle];
    [spinner setHidden:YES];
    [[webView superview] addSubview:spinner];
    
    serv = [[[OAuthLocalServer alloc] init] autorelease];
    [serv startWithDelegate:self];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:(NSString *)url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [[webView mainFrame] loadRequest:req];
}

- (IBAction)cancel:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    [spinner startAnimation:self];
    [spinner setHidden:NO];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [spinner stopAnimation:self];
    [spinner setHidden:YES];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if (connection)
        return;
    [spinner stopAnimation:self];
    [spinner setHidden:YES];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Error"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Couldn't connect to deviantART for some reason. You may not be connected to the Internet. Try again later."];
    [alert beginSheetModalForWindow:webWindow
                      modalDelegate:self
                     didEndSelector:@selector(loadFailed:)
                        contextInfo:nil];
}

- (void)loadFailed:(id)sender
{
    [[NSApplication sharedApplication] terminate:self];
}

@end
