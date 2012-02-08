//
//  HDTabBarView.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "TabButton.h"
#import "TabGhostView.h"

@class TabBar;

@interface TabView : NSView <NSDraggingDestination> {
    NSButton *dragger;
    NSInteger dragIndex;
    IBOutlet TabGhostView *dragImage;
}

@property (assign) TabBar *controller;

- (NSInteger)contentWidth;

#pragma mark -
#pragma mark Drag-n-Drop

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender;

@end
