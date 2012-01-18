//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"

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
    NSString *chatShell = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chat_shell" ofType:@"html"]] encoding:NSUTF8StringEncoding];
    NSString *styledShell = [NSString stringWithFormat:chatShell,
                             [ThemeHelper contentsOfThemeStylesheet:[[NSUserDefaults standardUserDefaults] objectForKey:@"themeName"]],
                             [[[self roomName] stringByReplacingOccurrencesOfString:@"#" withString:@""] lowercaseString],
                             html];
    
    [[chatView mainFrame] loadHTMLString:styledShell baseURL:[NSURL URLWithString:@"http://www.deviantart.com"]];
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
    
    NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] init] autorelease];
    NSString *us = [[[UserManager defaultManager] currentUser] objectForKey:@"username"];
    
    [str appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Logged in as %@", us]] autorelease]];
    [str addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://google.com"] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:[NSFont systemFontSize]] range:NSMakeRange(0, [str length])];
    [username setAttributedStringValue:str];
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

- (void)addLine:(Message *)str
{
    [lines addObject:str];
    NSString *addScript = [NSString stringWithFormat:@"createLine(\"%@\")", [str asHTML]];
    [chatView stringByEvaluatingJavaScriptFromString:addScript];
    NSInteger lineCount = [[chatView stringByEvaluatingJavaScriptFromString:@"lineCount()"] integerValue];
    if (lineCount > [[[NSUserDefaults standardUserDefaults] objectForKey:@"scrollbackLimit"] integerValue]) {
        [[lines objectAtIndex:0] release];
        [lines removeObjectAtIndex:0];
        [chatView stringByEvaluatingJavaScriptFromString:@"removeFirstLine()"];
    }
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
    return [item title];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![outlineView isExpandable:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [outlineView isExpandable:item];
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    [cell setAttributedStringValue:[[[NSAttributedString alloc] initWithString:[item title]] autorelease]];
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

@end
