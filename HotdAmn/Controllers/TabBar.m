//
//  HDTabBarController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabView.h"
#import "TabBar.h"
#import "HotDamn.h"

@implementation TabBar

@synthesize tabView;

- (id)init
{
    self = [super init];
    if (self) {
        _tabs = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSMutableDictionary *)tabs
{
    return _tabs;
}

- (void)awakeFromNib
{
    [tabView setController:self];
}

#pragma mark -
#pragma mark Button management

- (NSButton *)addButtonWithTitle:(NSString *)title
{
    if ([_tabs objectForKey:title]) {
        [self selectButton:[self getButtonWithTitle:title]];
        return [self getButtonWithTitle:title];
    }
    TabButton *b = [[[TabButton alloc] init] autorelease];
    TabButtonCell *cell = [[[TabButtonCell alloc] init] autorelease];
    [b setCell:cell];
    [[b cell] setImagePosition:NSImageRight];
    [[b cell] setAllowsMixedState:YES];
    [[b cell] setLineBreakMode:NSLineBreakByCharWrapping];
    [[b cell] setTruncatesLastVisibleLine:YES];
    [b setBordered:YES];
    [b setBezelStyle:NSRoundRectBezelStyle];
    [b setTitle:title];
    [b setRoomName:title];
    [b setIsPchat:[title rangeOfString:@"#"].location == NSNotFound];
    [b setTarget:self];
    [b setAction:@selector(selectButton:)];
    [b setCtrl:self];
    [b setFrame:[self getNextRect]];
    
    [tabView addSubview:b];
    [b createChatView];
    [b addTracker];
    [_tabs setObject:b forKey:[b roomName]];
    
    [self selectButton:b];
    
    return b;
}

- (void)selectButton:(NSButton *)button
{
    [self beforeChangeFrom:[self highlightedTab] toButton:nil];
    for(TabButton *b in [tabView subviews]) {
        if([[b title] isEqualToString:[button title]])
            [b select];
        else
            [b deselect];
    }
}

- (void)selectIndex:(NSInteger)index
{
    NSArray *views = [tabView subviews];
    
    // Apparently we want to activate the more-than-last button
    // just activate the last and return
    if (index >= [views count]) {
        [self beforeChangeFrom:[self highlightedTab] toButton:[views lastObject]];
        return [[views lastObject] select];
    }
    
    for(int i = 0; i < [views count]; i++) {
        if(index == i) {
            [self beforeChangeFrom:[self highlightedTab] toButton:[views objectAtIndex:i]];
            [[views objectAtIndex:i] select];
        } else [[views objectAtIndex:i] deselect];
    }
}

- (void)activateButtonWithTitle:(NSString *)title
{
    TabButton *b = [self getButtonWithTitle:title];
    if (!b) b = (TabButton *)[self addButtonWithTitle:title];
    [b setJoined:YES];
}

- (void)deactivateButtonWithTitle:(NSString *)title
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    TabButton *b = [self getButtonWithTitle:title];
    if (!b) b = (TabButton *)[self addButtonWithTitle:title];
    [b setJoined:NO];
    if ([[defs objectForKey:@"closeOnPart"] boolValue])
        [self removeButtonWithTitle:title];
}

- (void)removeHighlighted
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [object state] == 1 ? (*stop = YES) : NO;
    }];
    NSMutableArray *ar = [NSMutableArray arrayWithArray:[tabView subviews]];
    [ar removeObjectAtIndex:idx];
    [self handleLastTab:ar];
    [self selectIndex:idx];
}

- (void)removeButtonWithTitle:(NSString *)title
{
    NSMutableArray *buttons = [NSMutableArray arrayWithArray:[tabView subviews]];
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [[object roomName] isEqualToString:title] ? (*stop = YES) : NO;
    }];
    [[[[buttons objectAtIndex:idx] chatRoom] view] setHidden:YES];
    [buttons removeObjectAtIndex:idx];
    [self handleLastTab:buttons];
    [self selectIndex:idx];
}

- (void)hideButtonWithTitle:(NSString *)title
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [[object roomName] isEqualToString:title] ? (*stop = YES) : NO;
    }];
    [[[tabView subviews] objectAtIndex:idx] setHidden:YES];
    [self resizeButtons];
}

- (void)showButtonWithTitle:(NSString *)title
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [[object roomName] isEqualToString:title] ? (*stop = YES) : NO;
    }];
    [self beforeChangeFrom:[self highlightedTab] toButton:[[tabView subviews] objectAtIndex:idx]];
    [[[tabView subviews] objectAtIndex:idx] setHidden:NO];
    [self resizeButtons];
}

- (void)insertButton:(NSButton *)button atIndex:(NSInteger)idx fromIndex:(NSInteger)fromIdx
{
    [NSAnimationContext beginGrouping];
    
    [[NSAnimationContext currentContext] setDuration:0.25];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[NSAnimationContext currentContext] setCompletionHandler:^(void) {
        NSMutableArray *ary = [NSMutableArray arrayWithArray:[tabView subviews]];
        [ary removeObjectIdenticalTo:button];
        [ary insertObject:button atIndex:idx];
        [tabView setSubviews:ary];
        [self resizeButtons];
    }];
    
    NSButton *current = [[tabView subviews] objectAtIndex:idx];
    
    [[current animator] setFrameOrigin:NSMakePoint(SERVER_TAB_WIDTH + (fromIdx - 1) * TAB_WIDTH, [current frame].origin.y)];
    
    [NSAnimationContext endGrouping];
}

- (void)selectNext
{
    NSArray *tabs = [tabView subviews];
    for(int i = 0; i < [tabs count]; i++) {
        if([[tabs objectAtIndex:i] state] == 1) {
            [self beforeChangeFrom:[tabs objectAtIndex:i] toButton:nil];
            
            // Unhighlight the current tab.
            [[tabs objectAtIndex:i] deselect];
            
            // We are at the end of the tab bar, so highlight the first tab.
            if (i + 1 == [tabs count]) {
                [[tabs objectAtIndex:0] select];
            } else {
                [[tabs objectAtIndex:++i] select];
                [[tabs objectAtIndex:i] mouseUp:nil];
            }
            break;
        }
    }
    [self resizeButtons];
}

- (void)selectPrevious
{
    NSArray *tabs = [tabView subviews];
    for (int i = 0; i < [tabs count]; i++) {
        if([[tabs objectAtIndex:i] state] == 1) {
            [self beforeChangeFrom:[tabs objectAtIndex:i] toButton:nil];
            
            [[tabs objectAtIndex:i] deselect];
            if (i == 0) {
                [[tabs lastObject] select];
            } else {
                [[tabs objectAtIndex:--i] select];
                [[tabs objectAtIndex:i] mouseUp:nil];
            }
            break;
        }
    }
    [self resizeButtons];
}

- (NSInteger)indexOfRightmostButtonBeforePoint:(CGFloat)point
{
    float width = 0;
    int idx = 0;
    for (TabButton *button in [tabView subviews]) {
        float cellwidth = [button frame].size.width;
        width += cellwidth;
        
        if(width >= point) return idx > 0 ? idx : 1;
        
        ++idx;
    }
    return [tabView subviews].count - 1;
}

- (NSInteger)indexOfButtonWithTitle:(NSString *)title
{
    return [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger len, BOOL *stop) {
        return [[object roomName] isEqualToString:title] ? (*stop = YES) : NO;
    }];
}

- (TabButton *)getButtonWithTitle:(NSString *)title
{
    if ([self indexOfButtonWithTitle:title] == NSNotFound)
        return nil;
    return [[tabView subviews] objectAtIndex:[self indexOfButtonWithTitle:title]];
}

- (TabButton *)highlightedTab
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger len, BOOL *stop) {
        return [[object cell] state] == NSOnState;
    }];
    if ([[tabView subviews] count] > idx) {
        return [[tabView subviews] objectAtIndex:idx];
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark Geometry

- (NSRect)getNextRect
{
    NSRect bounds = [tabView bounds];
    NSRect nextRect = NSMakeRect([[tabView subviews] count] == 0 ? 0 : [[tabView subviews] count] * TAB_WIDTH - SERVER_TAB_WIDTH,
                                bounds.origin.y,
                                [[tabView subviews] count] == 0 ? SERVER_TAB_WIDTH : TAB_WIDTH,
                                bounds.size.height);
    return nextRect;
}

- (void)resizeButtons
{
    CGFloat totalWidth = ([[tabView subviews] count] - 1) * TAB_WIDTH + SERVER_TAB_WIDTH;
    CGFloat frame = [[[tabView window] contentView] frame].size.width;
    CGFloat ratio = frame / totalWidth;
    CGFloat newWidth = 0;
    for (int i = 0; i < [[tabView subviews] count]; i++) {
        TabButton *button = [[tabView subviews] objectAtIndex:i];
        NSRect newFrame = NSMakeRect(newWidth,
                                     [button frame].origin.y,
                                     (i == 0 ? SERVER_TAB_WIDTH : TAB_WIDTH) * (1.0f > ratio ? ratio : 1.0f),
                                     [button frame].size.height);
        [button setFrame:newFrame];
        newWidth += newFrame.size.width;
    }
}

- (void)fixHighlight
{
    for (NSButton *tab in [tabView subviews]) {
        if([tab state] == 1) {
            return;
        }
    }
    [[[tabView subviews] objectAtIndex:0] select];
}

- (void)handleLastTab:(NSArray *)tabs
{
    if ([tabs count] == 0) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:@"Are you sure you want to quit?"];
        [alert setInformativeText:@"Closing the server tab will quit the application."];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert beginSheetModalForWindow:[(HotDamn *)[[NSApplication sharedApplication] delegate] window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    } else {
        [tabView setSubviews:tabs];
        [self resizeButtons];
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int *)contextInfo
{
    if(returnCode == NSAlertFirstButtonReturn)
        [[NSApplication sharedApplication] terminate:nil];
}

- (void)beforeChangeFrom:(TabButton *)button1 toButton:(TabButton *)button2
{
    CGFloat sep = [button1 dividerPos];
    if (sep == 0)
        return;
    for (TabButton *b in [[self tabView] subviews]) {
        [b setDividerPos:sep];
    }
    [tabView setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_tabs release];
    [super dealloc];
}

@end
