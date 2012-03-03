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
    [filename setStringValue:[l location]];
}

@end
