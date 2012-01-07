//
//  HDTabBarController.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDTabBarView.h"
#import "HDTabButton.h"
#import "HDTabButtonCell.h"

@class HotDamn;

@interface TabBar : NSViewController

@property (retain) IBOutlet HDTabBarView *tabView;

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

- (NSInteger)indexOfRightmostButtonBeforePoint:(CGFloat)point;
- (NSInteger)indexOfButtonWithTitle:(NSString *)title;
- (NSButton *)getButtonWithTitle:(NSString *)title;

#pragma mark -
#pragma mark Geometry

- (NSRect)getNextRectWithLength:(NSInteger) length;
- (void)resizeButtons;

@end