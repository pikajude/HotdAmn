//
//  ScriptErrorSingle.m
//  HotdAmn
//
//  Created by Joel on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScriptErrorSingle.h"

@implementation ScriptErrorSingle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setLog:(LuaErrLog *)l
{
    NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] initWithString:[l location]] autorelease];
    
    NSShadow *shad = [[[NSShadow alloc] init] autorelease];
    [shad setShadowColor:[NSColor colorWithDeviceWhite:1.0f alpha:0.8f]];
    [shad setShadowOffset:NSMakeSize(0.0f, -1.0f)];
    [shad setShadowBlurRadius:1.0f];
    
    [str addAttribute:NSShadowAttributeName value:shad range:NSMakeRange(0, [str length])];
    
    [filename setAttributedStringValue:str];
}

@end
