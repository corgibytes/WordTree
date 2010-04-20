//
//  NSBezierPath_Additions.h
//  WordTree
//
//  Created by M. Scott Ford on 5/20/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import <Cocoa/Cocoa.h>


@interface NSBezierPath(BezierPathQuartzUtilities)

- (CGPathRef) quartzPath;

@end
