//
//  PathNames.h
//  WordTree
//
//  Created by M. Scott Ford on 2/19/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import <Cocoa/Cocoa.h>


@interface PathNames : NSObject<NSFastEnumeration> {
  NSArray* pathNames;
}

- (NSString*) pathNameAtIndex: (int) inedx;
- (int) count;

@end
