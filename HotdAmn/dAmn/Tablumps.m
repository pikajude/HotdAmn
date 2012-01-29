//
//  Tablumps.m
//  HotdAmn
//
//  Created by Joel on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Tablumps.h"

static NSString *tablumps_noregex[] = {
    @"&b\t", @"&/b\t", @"&i\t", @"&/i\t", @"&u\t", @"&/u\t", @"&s\t", @"&/s\t",
    @"&sup\t", @"&/sup\t", @"&sub\t", @"&/sub\t", @"&code\t", @"&/code\t",
    @"&br\t", @"&ul\t", @"&/ul\t", @"&ol\t", @"&/ol\t", @"&li\t", @"&/li\t",
    @"&bcode\t", @"&/bcode\t", @"&/a\t", @"&/acro\t", @"&/abbr\t", @"&p\t", @"&/p\t"
};

static NSString *tablumps_noregex_replace[] = {
    @"<b>", @"</b>", @"<i>", @"</i>", @"<u>", @"</u>", @"<s>", @"</s>",
    @"<sup>", @"</sup>", @"<sub>", @"</sub>", @"<code>", @"</code>",
    @"<br>", @"<ul>", @"</ul>", @"<ol>", @"</ol>", @"<li>", @"</li>",
    @"<pre>", @"</pre>", @"</a>", @"</acronym>", @"</abbr>", @"<p>", @"</p>"
};

static NSString *tablumps_regex[] = {
    @"&emote\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t",
    @"&a\t([^\t]+)\t([^\t]*)\t",
    @"&link\t([^\t]+)\t&\t",
    @"&link\t([^\t]+)\t([^\t]+)\t&\t",
    @"&img\t([^\t]+)\t([^\t]*)\t([^\t]*)\t",
    @"&dev\t([^\t]+)\t([^\t]+)\t",
    @"&acro\t([^\t]+)\t([^\t]+)",
    @"&abbr\t([^\t]+)\t([^\t]+)"
};

static NSString *tablumps_regex_replace[] = {
    @"<img alt='$1' width='$2' height='$3' alt='$4' src='http://e.deviantart.com/emoticons/$5' />",
    @"<a href='$1'>$2",
    @"<a href='$1'>[link]</a>",
    @"<a href='$1'>$2</a>",
    @"<img src='$1' alt='$2' title='$3' />",
    @"$1<a href='http://$2.deviantart.com'>$2</a>",
    @"<acronym title='$1'>$2",
    @"<abbr title='$1'>$2"
};

static NSString *tablumps_avatar = @"&avatar\\t([^\\t]+)\\t([0-9]+)\\t";
static NSString *tablumps_thumb = @"&thumb\t([0-9]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t";
static NSString *tablumps_iframe = @"&iframe\t([^\t]+)\t([0-9%]*)\t([0-9%]*)\t&\"iframe\t";

static void removeAvatarTablump(NSMutableString *str) {
    for (NSArray *matchGroup in [str arrayOfCaptureComponentsMatchedByRegex:tablumps_avatar]) {
        [str replaceOccurrencesOfString:[matchGroup objectAtIndex:0]
                             withString:[NSString stringWithFormat:@"<a href='http://%@.deviantart.com'><img src='%@' title=\"%@'s avatar\" /></a>",
                                        [matchGroup objectAtIndex:1],
                                        [AvatarManager avatarURLForUsername:[matchGroup objectAtIndex:1]
                                                                    userIcon:[[matchGroup objectAtIndex:2] integerValue]],
                                         [matchGroup objectAtIndex:1]]
                                options:NSCaseInsensitiveSearch
                                  range:NSMakeRange(0, [str length])];
    }
};

static void removeThumbTablump(NSMutableString *str) {
    for (NSArray *matchGroup in [str arrayOfCaptureComponentsMatchedByRegex:tablumps_thumb]) {
        [str replaceOccurrencesOfString:[matchGroup objectAtIndex:0]
                             withString:[NSString stringWithFormat:@"<a href='http://%@.deviantart.com/art/%@-%@'><img class='thumb' title='%@ by %@, %@' alt=':thumb%@:' src='http://th01.deviantart.com/%@' /></a>",
                                         [[matchGroup objectAtIndex:3] substringFromIndex:1],
                                         [[matchGroup objectAtIndex:2] stringByReplacingOccurrencesOfRegex:@"[^a-zA-Z0-9\\-]+" withString:@"-"],
                                         [matchGroup objectAtIndex:1],
                                         [matchGroup objectAtIndex:2],
                                         [matchGroup objectAtIndex:3],
                                         [matchGroup objectAtIndex:4],
                                         [matchGroup objectAtIndex:1],
                                         [[matchGroup objectAtIndex:6] stringByReplacingOccurrencesOfString:@":" withString:@"/"]
                                         ]
                                options:NSCaseInsensitiveSearch
                                  range:NSMakeRange(0, [str length])];
    }
};

@implementation Tablumps

+ (NSString *)removeTablumps:(NSString *)str
{
    assert(sizeof(tablumps_noregex) == sizeof(tablumps_noregex_replace));
    assert(sizeof(tablumps_regex) == sizeof(tablumps_regex_replace));
    NSMutableString *replacement = [[str mutableCopy] autorelease];
    for (int i = 0; i < sizeof(tablumps_noregex) / sizeof(tablumps_noregex[0]); i++) {
        [replacement replaceOccurrencesOfString:tablumps_noregex[i] withString:tablumps_noregex_replace[i] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [replacement length])];
    }
    
    for (int j = 0; j < sizeof(tablumps_regex) / sizeof(tablumps_regex[0]); j++) {
        [replacement replaceOccurrencesOfRegex:tablumps_regex[j] withString:tablumps_regex_replace[j]];
    }
    
    removeAvatarTablump(replacement);
    removeThumbTablump(replacement);
    
    return replacement;
}

@end
