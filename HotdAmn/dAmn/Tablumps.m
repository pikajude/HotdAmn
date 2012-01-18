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
    @"&dev\t([^\t]+)\t([^\t]+)\t",
    // @"&avatar\t([^\t]+)\t[0-9]+\t", special handling
    // @"&thumb\t([0-9]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t", special handling
    // @"&img\t([^\t]+)\t([^\t]*)\t([^\t]*)\t", special handling
    // @"&iframe\t([^\t]+)\t([0-9%]*)\t([0-9%]*)\t&\"iframe\t", special handling
    @"&acro\t([^\t]+)\t([^\t]+)",
    @"&abbr\t([^\t]+)\t([^\t]+)"
};

static NSString *tablumps_regex_replace[] = {
    @"<img alt='$1' width='$2' height='$3' alt='$4' src='http://e.deviantart.com/emoticons/$5'",
    @"<a href='$1'>$2",
    @"<a href='$1'>[link]</a>",
    @"<a href='$1'>$2</a>",
    @"$1<a href='http://$2.deviantart.com'>$2</a>",
    @"<acronym title='$1'>$2",
    @"<abbr title='$1'>$2"
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
    return replacement;
}

@end
