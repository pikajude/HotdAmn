//
//  HDApplicationController.m
//  HotdAmn
//
//  Created by Joel on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HDApplicationController.h"

const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation HDApplicationController

@synthesize window, appMenu;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
	[barControl addButtonWithTitle:@"Server" withTarget:barControl withAction:@selector(activateSingleButton:)];
}

- (NSString *)genRandStringLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
	}
		 
	return randomString;
}

- (IBAction)addTab:(id)sender
{
	NSString *title = [self genRandStringLength:8];
	[barControl addButtonWithTitle:title withTarget:barControl withAction:@selector(activateSingleButton:)];
}

- (IBAction)removeTab:(id)sender
{
	[barControl removeHighlighted];
}

- (IBAction)selectNextTab:(id)sender
{
	[barControl selectNext];
}

- (IBAction)selectPreviousTab:(id)sender
{
	[barControl selectPrevious];
}

@end
