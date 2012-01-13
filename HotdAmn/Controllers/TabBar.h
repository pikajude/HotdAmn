//
//  HDTabBarController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabButton.h"
#import "TabButtonCell.h"
#import "Preferences.h"

@class TabView;

@interface TabBar : NSViewController <PreferenceUpdateDelegate> {
    id currentTab;
    NSMutableDictionary *_tabs;
}

@property (retain) IBOutlet TabView *tabView;

- (NSMutableDictionary *)tabs;

#pragma mark -
#pragma mark Adding

- (void)addButtonWithTitle:(NSString *)title;
- (void)showButtonWithTitle:(NSString *)title;
- (void)activateSingleButton:(NSButton *)button;
- (void)activateSingleIndex:(NSInteger)index;
- (void)fixHighlight;
- (void)selectNext;
- (void)selectPrevious;
- (void)insertButton:(NSButton *)button atIndex:(NSInteger)idx;

#pragma mark -
#pragma mark Removing/Hiding

- (void)hideButtonWithTitle:(NSString *)title;
- (void)removeButtonWithTitle:(NSString *)title;
- (void)removeHighlighted;
- (void)handleLastTab:(NSArray *)tabs;

#pragma mark -
#pragma mark Querying

- (id)highlightedTab;
- (NSInteger)indexOfRightmostButtonBeforePoint:(CGFloat)point;
- (NSInteger)indexOfButtonWithTitle:(NSString *)title;
- (NSButton *)getButtonWithTitle:(NSString *)title;

#pragma mark -
#pragma mark Geometry

- (NSRect)getNextRectWithLength:(NSInteger) length;
- (void)resizeButtons;

#pragma mark -
#pragma mark Sizing

- (void)beforeChangeFrom:(id)button1 toButton:(id)button2;

#pragma mark -
#pragma mark Styling

- (void)chatFontDidChange;
- (void)inputFontDidChange;

@end