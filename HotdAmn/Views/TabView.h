//
//  HDTabBarView.h
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabButton.h"

@class TabBar;

@interface TabView : NSView <NSDraggingDestination> {
    NSButton *dragger;
    NSInteger dragIndex;
}

@property (assign) TabBar *controller;

- (NSInteger)contentWidth;

#pragma mark -
#pragma mark Drag-n-Drop

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender;

@end
