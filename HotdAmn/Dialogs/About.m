//
//  About.m
//  HotdAmn
//
//  Created by Joel on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"

@implementation About

@synthesize box;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"rtf"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSAttributedString *content = [[[NSAttributedString alloc] initWithRTF:data documentAttributes:NULL] autorelease];
    
    [[[box documentView] textStorage] setAttributedString:content];
    
    [[box documentView] setEditable:NO];
}

@end
