//
//  GlyphPaths.m
//  WordTree
//
//  Created by M. Scott Ford on 5/24/08.
//  Copyright 2008 Cogibytes, LLC. 
//

#import "GlyphPaths.h"

#import "NSBezierPath_Additions.h"

@interface GlyphPaths ()
- (CTLineRef) createLineForLetter: (NSString*) letter;
@end


@implementation GlyphPaths

- (id) initWithFont: (CTFontRef) initialFont {
  id result = [self init];
  
  font = initialFont;
  pathCache = [NSMutableDictionary dictionary];
  
  return result;
}

- (CGPathRef) pathForLetter: (NSString*) letter {
  CGPathRef result = (CGPathRef) [pathCache valueForKey: letter];
  if (result == nil) {    
    CTLineRef line = [self createLineForLetter: letter];
    
    CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
    CTRunRef glyphRun = (CTRunRef) CFArrayGetValueAtIndex(glyphRuns, 0);
    
    const CGGlyph* glyph = CTRunGetGlyphsPtr(glyphRun);
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, 0)];
    [path appendBezierPathWithGlyph: *glyph inFont: (NSFont*) font];
    [path closePath];
    
    result = [path quartzPath];
    [pathCache setValue: (id) result forKey: letter];
  }
  
  return result;
}

- (CTLineRef) createLineForLetter: (NSString*) letter {
  CFStringRef keys[] = { kCTFontAttributeName };
  CFTypeRef values[] = { font };
  
  CFDictionaryRef attributes =
  CFDictionaryCreate(kCFAllocatorDefault, (const void**) &keys,
                     (const void**) &values, sizeof(keys) / sizeof(keys[0]),
                     &kCFCopyStringDictionaryKeyCallBacks,
                     &kCFTypeDictionaryValueCallBacks);
  
  CFAttributedStringRef string = 
  CFAttributedStringCreate(kCFAllocatorDefault, 
                           (CFStringRef) letter, 
                           attributes); 
  
  CTLineRef line = CTLineCreateWithAttributedString(string);
  return line;
}


@end
