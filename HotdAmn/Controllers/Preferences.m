//
//  Preferences.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Preferences.h"
#import "PrefsUsers.h"

@implementation Preferences

@synthesize toolbar, general;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [toolbar setSelectedItemIdentifier:@"PrefsGeneral"];
    [self selectItem:general];
}

- (IBAction)selectItem:(id)sender
{
    NSString *nibName = [sender itemIdentifier];
    [[[self window] contentView] setSubviews:[NSArray array]];
    if (currentPanel != nil)
        [currentPanel release];
    Class cls = NSClassFromString(nibName);
    currentPanel = [[cls alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    CGFloat newHeight = [[currentPanel view] bounds].size.height +
                            ([[self window] frame].size.height -
                             [[[self window] contentView] frame].size.height);
    CGFloat newWidth = [[currentPanel view] bounds].size.width;
    CGFloat newOriginX = [[self window] frame].origin.x - (newWidth - [[self window] frame].size.width)/2.0f;
    CGFloat newOriginY = [[self window] frame].origin.y - newHeight + [[self window] frame].size.height;
    
    NSRect newRect = NSMakeRect(newOriginX, newOriginY, newWidth, newHeight);
    
    [NSAnimationContext beginGrouping];
    
    [[NSAnimationContext currentContext] setDuration:0.15f];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [[[self window] contentView] addSubview:[currentPanel view]];
    }];
    
    [[[self window] animator] setFrame:newRect display:NO];
    
    [NSAnimationContext endGrouping];
}

- (void)beforeDisplay
{
    if ([currentPanel respondsToSelector:@selector(beforeDisplay)]) {
        [(id)currentPanel beforeDisplay];
    }
}

@end
