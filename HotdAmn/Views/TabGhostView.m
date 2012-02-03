//
//  TabGhostView.m
//  HotdAmn
//
//  Created by Joel on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabGhostView.h"

@implementation TabGhostView

@synthesize parent;

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    [parent draggingUpdated:sender];
    return NSDragOperationNone;
}

@end
