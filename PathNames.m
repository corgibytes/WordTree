//
//  PathNames.m
//  WordTree
//
//  Created by M. Scott Ford on 2/19/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "PathNames.h"


@implementation PathNames

- (id) init
{
  self = [super init];
  if (self != nil) {
    pathNames = [NSArray arrayWithObjects:
                 @"path3183",
                 @"path3185",
                 @"path3187",
                 @"path3189",
                 @"path3191",
                 @"path3193",
                 @"path3192",
                 @"path3195",
                 @"path3197",
                 @"path3199",
                 @"path3201",
                 @"path3203",
                 @"path3205", 
                 nil];                 
  }
  return self;
}

- (NSString*) pathNameAtIndex: (int) index {
  return [pathNames objectAtIndex: index];
}

- (int) count {
  return [pathNames count];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
  return [pathNames countByEnumeratingWithState: state objects: stackbuf count: len];
}


@end
