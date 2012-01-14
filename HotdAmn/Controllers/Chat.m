//
//  Chat.m
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"

@implementation Chat

@synthesize roomName, delegate, split, chatContainer;

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
    [User addWatcher:self];
    [Topic addWatcher:self];
    [input bind:@"fontName"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontName"
        options:nil];
    
    [input bind:@"fontSize"
       toObject:[NSUserDefaultsController sharedUserDefaultsController]
    withKeyPath:@"values.inputFontSize"
        options:nil];
    
    NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] init] autorelease];
    NSString *us = [[[UserManager defaultManager] currentUser] objectForKey:@"username"];
    
    [str appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Logged in as %@", us]] autorelease]];
    [str addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://google.com"] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:[NSFont systemFontSize]] range:NSMakeRange(0, [str length])];
    [username setAttributedStringValue:str];
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
        return [[[User listForRoom:roomName] children] objectAtIndex:index];
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
        return [[[User listForRoom:roomName] children] count];
    }
    return [[item children] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [item title];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![outlineView isExpandable:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [outlineView isExpandable:item];
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    [cell setAttributedStringValue:[[[NSAttributedString alloc] initWithString:[item title]] autorelease]];
}

- (void)onUserListUpdated
{
    [userList reloadData];
    [userList expandItem:nil expandChildren:YES];
}

- (void)onTopicChange
{
    NSString *top = [Topic topicForRoom:[self roomName]];
    if (top == NULL) {
        top = @"";
    }
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@",
                       [[[UserManager defaultManager] currentUser] objectForKey:@"username"],
                       roomName,
                       [top substringToIndex:[top length] > 0 ? 16 : 0]];
    [[[self view] window] setTitle:title];
}

@end
