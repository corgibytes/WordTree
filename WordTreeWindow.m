//
//  WordTreeWindow.m
//  WordTree
//
//  Created by M. Scott Ford on 2/19/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "WordTreeWindow.h"


@implementation WordTreeWindow

- (void) sendEvent: (NSEvent*) event {  
  if ([event type] == NSKeyUp) {
    [[self windowController] keyUp: event];
  } else if ([event type] == NSKeyDown) {
    // ignore keydown events. This prevents beeping.
  } else {
    [super sendEvent: event];
  }
}


@end
