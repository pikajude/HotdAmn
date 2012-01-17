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
        // Initialization code here.
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

- (BOOL)highlight {
    return NO;
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
    if ([[[self user] username] isEqualToString:[[[UserManager defaultManager] currentUser] objectForKey:@"username"]]) {
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

- (NSString *)asHTML
{
    return [NSString stringWithFormat:@"<li class='%@'><timestamp>%@</timestamp> * <line>%@</line></li>",
            [self cssClasses],
            [self timestamp],
            [content stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
}

- (void)dealloc
{
    [content release];
    [super dealloc];
}

@end
