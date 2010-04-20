//
//  LetterLayer.h
//  WordTree
//
//  Created by M. Scott Ford on 3/2/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import "GlyphPaths.h"


@interface LetterLayer : CALayer {
  NSString* letter;
  CTFontRef font;
  CGColorRef foregroundColor;
  CGPathRef cachedPath;
  GlyphPaths* glyphPaths;
}

+ (id) layerWithLetter: (NSString*) letter;
+ (id) layerWithLetter: (NSString*) letter usingFont: (CTFontRef) font;

- (NSString*) letter;
- (void) setLetter: (NSString*) letter;

- (CTFontRef) font;
- (void) setFont: (CTFontRef) font;

- (CGColorRef) foregroundColor;
- (void) setForegroundColor: (CGColorRef) color;

@end
