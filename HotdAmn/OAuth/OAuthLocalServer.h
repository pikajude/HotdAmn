//
//  OAuthLocalServer.h
//  HotdAmn
//
//  Created by Joel on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthLocalServer : NSObject {
    CFSocketRef sock;
    NSFileHandle *handle;
}

- (void)startWithDelegate:(id)delegate;

@end
