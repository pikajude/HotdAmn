//
//  Message.m
//  HotdAmn
//
//  Created by Joel on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize content, date;

- (id)init
{
    self = [super init];
    if (self) {
        highlight = NO;
    }
    
    return self;
}

- (id)initWithContent:(NSString *)cont
{
    self = [super init];
    content = [cont retain];
    date = [NSDate date];
    return self;
}

- (User *)user {
    return nil;
}

- (void)setHighlight:(BOOL)h
{
    highlight = h;
}

- (BOOL)highlight {
    return highlight;
}

static NSDictionary *symbolTable() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"member", [NSNumber numberWithChar:'~'],
            @"premium-member", [NSNumber numberWithChar:'*'],
            @"beta-tester", [NSNumber numberWithChar:'='],
            @"senior-member", [NSNumber numberWithChar:'`'],
            @"alumni", [NSNumber numberWithChar:176], // °
            @"banned", [NSNumber numberWithChar:'!'],
            @"general-admin", [NSNumber numberWithChar:'+'],
            @"creative-team", [NSNumber numberWithChar:162], // ¢
            @"volunteer", [NSNumber numberWithChar:'^'],
            @"admin", [NSNumber numberWithChar:'$'],
            @"official", [NSNumber numberWithChar:163], // £
            nil];
}

- (NSString *)cssClasses
{
    NSMutableArray *classes = [NSMutableArray arrayWithObject:@"message"];
    if ([self highlight]) [classes addObject:@"highlight"];
    if ([[[self user] username] isEqualToString:[[UserManager defaultManager] currentUsername]]) {
        [classes addObject:@"mine"];
    }
    if ([self user]) {
        [classes addObject:[NSString stringWithFormat:@"user-%@", [[self user] username]]];
        [classes addObject:[symbolTable() objectForKey:[NSNumber numberWithChar:[[self user] symbol]]]];
    } else
        [classes addObject:@"server-msg"];
    return [classes componentsJoinedByString:@" "];
}

- (NSString *)timestamp
{
    NSString *format = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestampFormat"];
    NSDateFormatter *form = [[[NSDateFormatter alloc] initWithDateFormat:format allowNaturalLanguage:YES] autorelease];
    return [form stringFromDate:[NSDate date]];
}

- (NSString *)asText
{
    return [self content];
}

- (void)dealloc
{
    [content release];
    [super dealloc];
}

@end
