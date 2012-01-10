//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"

@implementation Chat

@synthesize chatView, chatParent, userView, chatContainer, input, delegate, split;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lines = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex
{
    CGFloat lowerLimit = 100.0f;
    CGFloat upperLimit = [splitView bounds].size.width - 50.0f;
    CGFloat newpos = proposedPosition > upperLimit ? upperLimit : proposedPosition < lowerLimit ? lowerLimit : proposedPosition;
    return newpos;
}

- (void)selectInput
{
    [input becomeFirstResponder];
}

- (void)addLine:(NSString *)str
{
    [lines addObject:[NSString stringWithFormat:@"<li>%@</li>", str]];
    if ([lines count] > 1500)
        [lines removeObjectAtIndex:0];
    NSString *cont = [NSString stringWithFormat:@"<ul>%@</ul>", [lines componentsJoinedByString:@""]];
    [[chatView mainFrame] loadHTMLString:cont baseURL:[NSURL URLWithString:@"http://www.deviantart.com"]];
}

@end
