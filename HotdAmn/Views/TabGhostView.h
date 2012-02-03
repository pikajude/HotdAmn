//
//  TabGhostView.h
//  HotdAmn
//
//  Created by Joel on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface TabGhostView : NSImageView <NSDraggingDestination>

@property (retain) id<NSDraggingDestination> parent;

@end
