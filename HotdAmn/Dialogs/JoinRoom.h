//
//  HDJoinRoomController.h
//  HotdAmn
//
//  Created by Joel on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HotDamn;

@interface JoinRoom : NSWindowController

@property (retain) IBOutlet NSTextField *roomName;
@property (retain) IBOutlet NSTextField *errMsg;
@property (assign) id delegate;

- (IBAction)joinRoom:(id)sender;
- (IBAction)cancelRoom:(id)sender;

@end
