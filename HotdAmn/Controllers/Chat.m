//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"
#import "HotDamn.h"

@implementation Chat

@synthesize roomName, delegate, split, chatContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil roomName:(NSString *)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    roomName = name;
    
    return self;
}

#pragma mark -
#pragma mark Theme management

- (void)loadTheme:(NSString *)html;
{
    NSString *chatShell = [[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chat_shell" ofType:@"html"]] encoding:NSUTF8StringEncoding] autorelease];
    NSString *styledShell = [NSString stringWithFormat:chatShell,
                             [ThemeHelper contentsOfThemeStylesheet:[[NSUserDefaults standardUserDefaults] objectForKey:@"themeName"]],
                             [[[self roomName] stringByReplacingOccurrencesOfString:@"#" withString:@""] lowercaseString],
                             html];
    
    [[chatView mainFrame] loadHTMLString:styledShell baseURL:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"values.themeName"] || [keyPath isEqualToString:@"values.timestampFormat"]) {
        NSMutableArray *ar = [NSMutableArray array];
        for (Message *line in lines) {
            [ar addObject:[line asHTML]];
        }
        [self loadTheme:[ar componentsJoinedByString:@""]];
    }
}

#pragma mark -

- (void)awakeFromNib
{
    lines = [[NSMutableArray alloc] init];
    [self loadTheme:@""];
    [User addWatcher:self];
    [Topic addWatcher:self];
    
    [[NSUserDefaultsController sharedUserDefaultsController]
        addObserver:self
         forKeyPath:@"values.themeName"
            options:NSKeyValueObservingOptionNew
            context:nil];
    
    [[NSUserDefaultsController sharedUserDefaultsController]
        addObserver:self
         forKeyPath:@"values.timestampFormat"
            options:NSKeyValueObservingOptionNew
            context:nil];
    
    [input bind:@"fontName"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontName"
        options:nil];
    
    [input bind:@"fontSize"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontSize"
        options:nil];
    
    [input setTarget:self];
    [input setAction:@selector(say:)];
    [input setDelegate:self];
    
    NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] init] autorelease];
    NSString *us = [[[UserManager defaultManager] currentUser] objectForKey:@"username"];
    
    [str appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Logged in as %@", us]] autorelease]];
    [str addAttribute:NSLinkAttributeName
                value:[NSURL URLWithString:@"http://google.com"]
                range:NSMakeRange(0, [str length])];
    [str addAttribute:NSFontAttributeName
                value:[NSFont systemFontOfSize:[NSFont systemFontSize]]
                range:NSMakeRange(0, [str length])];
    
    [username setAttributedStringValue:str];
}

- (void)say:(id)sender
{
    if ([[sender stringValue] isEqualToString:@""])
        return;
    [[(HotDamn *)[[NSApplication sharedApplication] delegate] evtHandler]
                say:[sender stringValue]
             toRoom:[self roomName]];
    [sender setStringValue:@""];
    [sender selectText:nil];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
    return view == cShell || view == uShell;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex
{
    CGFloat lowerLimit = 100.0f;
    CGFloat upperLimit = [splitView bounds].size.width - 50.0f;
    CGFloat newpos = proposedPosition > upperLimit ? upperLimit : proposedPosition < lowerLimit ? lowerLimit : proposedPosition;
    return newpos;
}

- (void)selectInput
{
    [input becomeFirstResponder];
}

static void notifyHighlight(Chat *chat, Message *str) {
    NSString *notName = [str isKindOfClass:[UserMessage class]] ? @"User Mentioned" : @"Buddy Joined";
    [GrowlApplicationBridge notifyWithTitle:[chat roomName]
                                description:[str asText]
                            notificationName:notName
                                    iconData:[[NSApp applicationIconImage] TIFFRepresentation]
                                    priority:0
                                    isSticky:NO
                                clickContext:nil];
}

- (void)addLine:(Message *)str
{
    if ([str highlight]) {
        notifyHighlight(self, str);
    }
    
    [lines addObject:str];
    NSString *addScript = [NSString stringWithFormat:@"createLine(\"%@\")", [str asHTML]];
    [chatView stringByEvaluatingJavaScriptFromString:addScript];
    NSInteger lineCount = [[chatView stringByEvaluatingJavaScriptFromString:@"lineCount()"] integerValue];
    if (lineCount > [[[NSUserDefaults standardUserDefaults] objectForKey:@"scrollbackLimit"] integerValue]) {
        [lines removeObjectAtIndex:0];
        [chatView stringByEvaluatingJavaScriptFromString:@"removeFirstLine()"];
    }
    [str autorelease];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (!item) {
        return [[[User listForRoom:roomName] children] objectAtIndex:index];
    }
    return [[item children] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (!item) {
        return YES;
    }
    return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return [[[User listForRoom:roomName] children] count];
    }
    return [[item children] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item joinCount] < 2) {
        return [item title];
    } else {
        return [NSString stringWithFormat:@"%@[%ld]", [item title], [item joinCount]];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![outlineView isExpandable:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [outlineView isExpandable:item];
}

- (void)onUserListUpdated
{
    [userList reloadData];
    [userList expandItem:nil expandChildren:YES];
}

- (void)onTopicChange
{
    NSString *top = [Topic topicForRoom:[self roomName]];
    if (top == NULL) {
        top = @"";
    }
    NSString *title = [NSString stringWithFormat:@"%@ — %@",
                       [[[UserManager defaultManager] currentUser] objectForKey:@"username"],
                       [self roomName]];
    [[[self view] window] setTitle:title];
    [chatView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTopic(\"%@\")",
                                                      [top stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]]];
}

- (NSMenu *)menuForOutlineView:(NSOutlineView *)view byItem:(id)item
{
    if (![item isLeaf])
        return nil;
    
    NSMenu *m = [[[NSMenu alloc] initWithTitle:[item title]] autorelease];
    NSMenuItem *it = [[[NSMenuItem alloc] initWithTitle:[item title] action:nil keyEquivalent:@""] autorelease];
    [m addItem:it];
    return m;
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if([[request URL] host]) {
        [listener ignore];
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    } else {
        [listener use];
    }
}

#pragma mark -
#pragma mark Tab completion

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector != @selector(insertTab:))
        return NO;
    tabcmp *res = [TabCompletion completePartialString:[[textView textStorage] string]
                                               details:[self roomName]
                                        cursorLocation:[[[textView selectedRanges] objectAtIndex:0] rangeValue].location];
    if ([res->content isEqualToString:[[textView textStorage] string]]) {
        NSBeep();
        return YES;
    }
    [textView setString:res->content];
    [textView setSelectedRange:NSMakeRange(res->cursorLocation, 0)];
    free(res);
    return YES;
}

@end
