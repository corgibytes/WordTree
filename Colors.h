//
//  Colors.h
//  WordTree
//
//  Created by M. Scott Ford on 2/20/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import <Cocoa/Cocoa.h>


@interface Colors : NSObject {

}

+ (CGColorRef) clear;
+ (CGColorRef) darkGreen;
+ (CGColorRef) darkBrown;
+ (CGColorRef) black;
+ (CGColorRef) white;
+ (CGColorRef) orange;
+ (CGColorRef) maroon;

+ (CGColorRef) fromColor: (NSColor*) color;

@end
