//
//  HDTabBarController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HDTabBarController.h"
#import "HotDamn.h"

@implementation HDTabBarController

@synthesize tabView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [tabView setController:self];
}

#pragma mark -
#pragma mark Button management

- (void)addButtonWithTitle:(NSString *)title
{
    HDTabButton *b = [[[HDTabButton alloc] init] autorelease];
    HDTabButtonCell *cell = [[[HDTabButtonCell alloc] init] autorelease];
    [b setCell:cell];
    [[b cell] setImagePosition:NSImageRight];
    [[b cell] setAllowsMixedState:YES];
    [b setBordered:YES];
    [b setBezelStyle:NSRoundRectBezelStyle];
    [b setTitle:title];
    [b setTarget:self];
    [b setAction:@selector(activateSingleButton:)];
    [b setCtrl:self];
    
    [tabView addSubview:b];
    
    [b setFrame:[self getNextRectWithLength:[[b cell] cellSize].width]];
    [b addTracker];
    [self activateSingleButton:b];
}

- (void)activateSingleButton:(NSButton *)button
{
    for(HDTabButton *b in [tabView subviews]) {
        if([[b title] isEqualToString:[button title]]) [b select];
        else [b deselect];
    }
}

- (void)activateSingleIndex:(NSInteger)index
{
    NSArray *views = [tabView subviews];
    
    // Apparently we want to activate the more-than-last button
    // just activate the last and return
    if (index >= [views count]) return [[views lastObject] select];
    
    for(int i = 0; i < [views count]; i++) {
        if(index == i) [[views objectAtIndex:i] select];
        else [[views objectAtIndex:i] deselect];
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
            
            // Unhighlight the current tab.
            [[tabs objectAtIndex:i] deselect];
            
            // We are at the end of the tab bar, so highlight the first tab.
            if (i + 1 == [tabs count]) {
                [[tabs objectAtIndex:0] select];
            } else {
                [[tabs objectAtIndex:++i] select];
            }
            break;
        }
    }
}

- (void)selectPrevious
{
    NSArray *tabs = [tabView subviews];
    for (int i = 0; i < [tabs count]; i++) {
        if([[tabs objectAtIndex:i] state] == 1) {
            [[tabs objectAtIndex:i] deselect];
            if (i == 0) {
                [[tabs lastObject] select];
            } else {
                [[tabs objectAtIndex:--i] select];
            }
            break;
        }
    }
}

- (NSInteger)indexOfRightmostButtonBeforePoint:(CGFloat)point
{
    float width = 0;
    int idx = 0;
    for (HDTabButton *button in [tabView subviews]) {
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
    [tabs release];
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

@end
