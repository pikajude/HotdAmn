//
//  HDTabBarController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabView.h"
#import "TabBar.h"
#import "TabButton.h"
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

- (void)addButtonWithTitle:(NSString *)title
{
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
    [b setTarget:self];
    [b setAction:@selector(activateSingleButton:)];
    [b setCtrl:self];
    
    [tabView addSubview:b];
    
    [b createChatView];
    [b setFrame:[self getNextRectWithLength:[[b cell] cellSize].width]];
    [b addTracker];
    [_tabs setObject:b forKey:[b roomName]];
    [self activateSingleButton:b];
}

- (void)activateSingleButton:(NSButton *)button
{
    [self beforeChangeFrom:[self highlightedTab] toButton:nil];
    for(TabButton *b in [tabView subviews]) {
        if([[b title] isEqualToString:[button title]]) {
            currentTab = b;
            [b select];
        } else [b deselect];
    }
}

- (void)activateSingleIndex:(NSInteger)index
{
    NSArray *views = [tabView subviews];
    
    // Apparently we want to activate the more-than-last button
    // just activate the last and return
    if (index >= [views count]) {
        [self beforeChangeFrom:[self highlightedTab] toButton:[views lastObject]];
        currentTab = [views lastObject];
        return [[views lastObject] select];
    }
    
    for(int i = 0; i < [views count]; i++) {
        if(index == i) {
            [self beforeChangeFrom:[self highlightedTab] toButton:[views objectAtIndex:i]];
            currentTab = [views objectAtIndex:i];
            [[views objectAtIndex:i] select];
        } else [[views objectAtIndex:i] deselect];
    }
}

- (void)removeHighlighted
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [object state] == 1 ? (*stop = YES) : NO;
    }];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(state != 1)"];
    NSArray *validViews = [[tabView subviews] filteredArrayUsingPredicate:pred];
    [self handleLastTab:validViews];
    [self activateSingleIndex:idx];
}

- (void)removeButtonWithTitle:(NSString *)title
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(title != %@)", title];
    NSArray *validViews = [[tabView subviews] filteredArrayUsingPredicate:pred];
    [self handleLastTab:validViews];
}

- (void)hideButtonWithTitle:(NSString *)title
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [[object title] isEqualToString:title] ? (*stop = YES) : NO;
    }];
    [[[tabView subviews] objectAtIndex:idx] setHidden:YES];
    [self resizeButtons];
}

- (void)showButtonWithTitle:(NSString *)title
{
    NSInteger idx = [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        return [[object title] isEqualToString:title] ? (*stop = YES) : NO;
    }];
    [self beforeChangeFrom:[self highlightedTab] toButton:[[tabView subviews] objectAtIndex:idx]];
    [[[tabView subviews] objectAtIndex:idx] setHidden:NO];
    [self resizeButtons];
}

- (void)insertButton:(NSButton *)button atIndex:(NSInteger)idx
{
    NSMutableArray *ary = [[[tabView subviews] mutableCopy] autorelease];
    [ary removeObjectIdenticalTo:button];
    [ary insertObject:button atIndex:idx];
    [tabView setSubviews:ary];
    [self resizeButtons];
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
                currentTab = [tabs objectAtIndex:0];
            } else {
                [[tabs objectAtIndex:++i] select];
                currentTab = [tabs objectAtIndex:i];
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
                currentTab = [tabs lastObject];
            } else {
                [[tabs objectAtIndex:--i] select];
                currentTab = [tabs objectAtIndex:i];
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
        // Round off tab rearranging - i.e. if the tab is more than 50%
        // of the way on either side, return the proper index
        float cellwidth = [[button cell] cellSize].width;
        width += cellwidth;
        
        if(width >= point) return idx > 0 ? idx : 1;
        
        ++idx;
    }
    return [tabView subviews].count - 1;
}

- (NSInteger)indexOfButtonWithTitle:(NSString *)title
{
    return [[tabView subviews] indexOfObjectPassingTest:^BOOL(id object, NSUInteger len, BOOL *stop) {
        return [[object title] isEqualToString:title] ? (*stop = YES) : NO;
    }];
}

- (NSButton *)getButtonWithTitle:(NSString *)title
{
    return [[tabView subviews] objectAtIndex:[self indexOfButtonWithTitle:title]];
}

- (TabButton *)highlightedTab
{
    return currentTab;
}

#pragma mark -
#pragma mark Geometry

- (NSRect)getNextRectWithLength:(NSInteger)length
{
    NSRect bounds = [tabView bounds];
    NSRect nextRect = NSMakeRect(bounds.origin.x + [tabView contentWidth],
                                bounds.origin.y,
                                length + 8.0f,
                                bounds.size.height);
    return nextRect;
}

- (void)resizeButtons
{
    NSArray *tabs = [[tabView subviews] copy];
    [tabView setSubviews:[NSArray array]];
    for (NSButton *tab in tabs) {
        [tab setFrame:[self getNextRectWithLength:[[tab cell] cellSize].width]];
        [tabView addSubview:tab];
    }
    for (TabButton *b in tabs) {
        [_tabs setObject:b forKey:[b title]];
    }
    [tabs release];
}

- (void)scaleButtons
{
    NSInteger totalWidth = [tabView contentWidth];
    NSInteger frame = [[[tabView window] contentView] frame].size.width;
    CGFloat ratio = (float)frame / (float)totalWidth;
    if (ratio > 1.0f) {
        [self resizeButtons]; // ensure we reach 100% width even if window expands quickly
    } else {
        CGFloat newWidth = 0;
        for (int i = 0; i < [[tabView subviews] count]; i++) {
            TabButton *button = [[tabView subviews] objectAtIndex:i];
            NSRect newFrame = NSMakeRect(newWidth,
                                         [button frame].origin.y,
                                         ([[button cell] cellSize].width + 8) * ratio,
                                         [button frame].size.height);
            [button setFrame:newFrame];
            newWidth += newFrame.size.width;
        }
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
}

- (void)dealloc
{
    [_tabs release];
    [super dealloc];
}

@end
