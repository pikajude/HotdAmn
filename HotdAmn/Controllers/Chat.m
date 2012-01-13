//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"

@implementation Chat

@synthesize chatView, chatParent, chatContainer, input, delegate, split;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lines = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [input bind:@"fontName"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontName"
        options:nil];
    
    [input bind:@"fontSize"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontSize"
        options:nil];
    
    testChild = [[UserListNode alloc] init];
    UserListNode *group1 = [[UserListNode alloc] init];
    UserListNode *user1 = [[UserListNode alloc] init];
    UserListNode *user2 = [[UserListNode alloc] init];
    [group1 setTitle:@"Privclass"];
    [user1 setTitle:@"User 1"];
    [user2 setTitle:@"User 2"];
    [group1 addChildren:[NSArray arrayWithObjects:user1, user2, nil]];
    [testChild addChild:group1];
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

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (!item) {
        return [[testChild children] objectAtIndex:index];
    }
    return [[item children] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (!item) {
        return YES;
    }
    return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return [[testChild children] count];
    }
    return [[item children] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [item title];
}

@end
