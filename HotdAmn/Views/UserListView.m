//
//  UserListView.m
//  HotdAmn
//
//  Created by Joel on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserListView.h"
#import "Chat.h"

@implementation UserListView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
{
    return NSZeroRect;
}

- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row {
    NSRect superFrame = [super frameOfCellAtColumn:column row:row];
    
    if (![self isExpandable:[self itemAtRow:row]]) {
        return NSMakeRect(13.0f,
                          superFrame.origin.y,
                          [self bounds].size.width - 6.0f,
                          superFrame.size.height);
    } else {
        return NSMakeRect(4.0f, superFrame.origin.y, [self bounds].size.width - 4.0f, superFrame.size.height);
    }
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    NSPoint where = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:where];
    if (row < 0) return nil;
    return [(Chat *)[self dataSource] menuForOutlineView:self byItem:[self itemAtRow:row]];
}

@end
