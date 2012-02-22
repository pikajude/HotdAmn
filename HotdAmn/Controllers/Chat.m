//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"
#import "HotDamn.h"
#import "PrefsUsers.h"

@implementation Chat

@synthesize roomName, delegate, split, chatContainer, userList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil roomName:(NSString *)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setRoomName:name];
    
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
            [ar addObject:[MessageFormatter formatMessage:line]];
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
    [input setDelegate:self];
}

- (void)say:(id)sender unparsed:(BOOL)unparsed
{
    EventHandler *receiver = [(HotDamn *)[[NSApplication sharedApplication] delegate] evtHandler];
    if ([[sender stringValue] isEqualToString:@""])
        return;
    NSString *cont;
    if (unparsed) {
        [receiver sayUnparsed:[sender stringValue] inRoom:[self roomName]];
    } else if ([[sender stringValue] hasPrefix:@"//"] || ![[sender stringValue] hasPrefix:@"/"]) {
        if ([[sender stringValue] hasPrefix:@"/"]) {
            cont = [[sender stringValue] substringFromIndex:1];
        } else {
            cont = [sender stringValue];
        }
        [receiver say:cont inRoom:[self roomName]];
    } else {
        NSArray *pieces = [[[sender stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@" "];
        NSString *cmdName = [[pieces objectAtIndex:0] substringFromIndex:1];
        LuaCommand *c = [LuaCommand commandWithName:cmdName];
        if (c == nil) {
            [self error:[NSString stringWithFormat:@"Unknown command %@.", cmdName]];
        } else {
            [c execute];
        }
    }
    [sender setStringValue:@""];
    [sender selectText:nil];
}

- (void)error:(NSString *)errMsg
{
    NSLog(@"%@", errMsg);
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
    NSString *addScript = [NSString stringWithFormat:@"createLine(\"%@\")", [MessageFormatter formatMessage:str]];
    [chatView stringByEvaluatingJavaScriptFromString:addScript];
    NSInteger lineCount = [[chatView stringByEvaluatingJavaScriptFromString:@"lineCount()"] integerValue];
    if (lineCount > [[[NSUserDefaults standardUserDefaults] objectForKey:@"scrollbackLimit"] integerValue]) {
        [lines removeObjectAtIndex:0];
        [chatView stringByEvaluatingJavaScriptFromString:@"removeFirstLine()"];
    }
}

- (BOOL)isPchat
{
    return [[self roomName] rangeOfString:@"#"].location == NSNotFound;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if ([self isPchat]) return [[[[[User listForRoom:roomName] children] objectAtIndex:0] children] objectAtIndex:index];
    if (!item) {
        return [[[User listForRoom:roomName] children] objectAtIndex:index];
    }
    return [[item children] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([self isPchat]) return NO;
    if (!item) {
        return YES;
    }
    return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if ([self isPchat]) return [[[[[User listForRoom:roomName] children] objectAtIndex:0] children] count];
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
    NSString *title = [NSString stringWithFormat:@"%@ — %@",
                       [[UserManager defaultManager] currentUsername],
                       [self roomName]];
    [[[self view] window] setTitle:title];
}

- (NSMenu *)menuForOutlineView:(NSOutlineView *)view byItem:(id)item
{
    if (![item isLeaf])
        return nil;
    
    NSArray *buddy = fieldForUser(@"buddies", [[UserManager defaultManager] currentUsername]);
    NSArray *ignore = fieldForUser(@"ignores", [[UserManager defaultManager] currentUsername]);
    
    NSMenu *m = [[[NSMenu alloc] initWithTitle:[item title]] autorelease];
    
    NSMenuItem *pm = [[[NSMenuItem alloc] initWithTitle:@"Open private message" action:@selector(startPchat:) keyEquivalent:@""] autorelease];
    [pm setTarget:[[NSApplication sharedApplication] delegate]];
    [pm setRepresentedObject:[item title]];
    
    NSMenuItem *whois = [[[NSMenuItem alloc] initWithTitle:@"Whois" action:@selector(whois:) keyEquivalent:@""] autorelease];
    [whois setTarget:self];
    [whois setRepresentedObject:[item title]];
    
    NSMenuItem *buddyItem = [[[NSMenuItem alloc] init] autorelease];
    [buddyItem setTarget:self];
    [buddyItem setKeyEquivalent:@""];
    [buddyItem setRepresentedObject:[item title]];
    if ([buddy containsObject:[item title]]) {
        [buddyItem setTitle:@"Remove buddy"];
        [buddyItem setAction:@selector(removeBuddy:)];
    } else {
        [buddyItem setTitle:@"Add buddy"];
        [buddyItem setAction:@selector(addBuddy:)];
    }
    
    NSMenuItem *ignoreItem = [[[NSMenuItem alloc] init] autorelease];
    [ignoreItem setTarget:self];
    [ignoreItem setKeyEquivalent:@""];
    [ignoreItem setRepresentedObject:[item title]];
    if ([ignore containsObject:[item title]]) {
        [ignoreItem setTitle:@"Unignore"];
        [ignoreItem setAction:@selector(removeIgnore:)];
    } else {
        [ignoreItem setTitle:@"Ignore"];
        [ignoreItem setAction:@selector(addIgnore:)];
    }
    
    [m addItem:buddyItem];
    [m addItem:ignoreItem];
    [m addItem:pm];
    [m addItem:whois];
    return m;
}

- (void)whois:(id)sender
{
    EventHandler *eventHandler = [(HotDamn *)[[NSApplication sharedApplication] delegate] evtHandler];
    [eventHandler whois:[sender representedObject]];
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
    if (commandSelector == @selector(insertTab:)) {
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
    } else if (commandSelector == @selector(insertNewline:)) {
        [self say:control unparsed:([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask ? YES : NO)];
        return YES;
    }
    return NO;
}

- (void)addBuddy:(id)sender
{
    NSString *username = [sender representedObject];
    addObjectToFieldForUser(username, @"buddies", [[UserManager defaultManager] currentUsername]);
}

- (void)removeBuddy:(id)sender
{
    NSString *username = [sender representedObject];
    removeObjectFromFieldForUser(username, @"buddies", [[UserManager defaultManager] currentUsername]);
}

- (void)addIgnore:(id)sender
{
    NSString *username = [sender representedObject];
    addObjectToFieldForUser(username, @"ignores", [[UserManager defaultManager] currentUsername]);
}

- (void)removeIgnore:(id)sender
{
    NSString *username = [sender representedObject];
    removeObjectFromFieldForUser(username, @"ignores", [[UserManager defaultManager] currentUsername]);
}

- (void)dealloc
{
    [Topic removeWatcher:self];
    [User removeWatcher:self];
    [super dealloc];
}

@end
