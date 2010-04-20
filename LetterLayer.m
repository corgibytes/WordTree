//
//  LetterLayer.m
//  WordTree
//
//  Created by M. Scott Ford on 3/2/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "LetterLayer.h"

#import <ApplicationServices/ApplicationServices.h>

#import "Colors.h"

@interface LetterLayer() 
- (void) setGlyphPaths: (GlyphPaths*) newGlyphPaths;
@end

@implementation LetterLayer

+ (id) layerWithLetter: (NSString*) letter {
  CTFontRef font = CTFontCreateWithName((CFStringRef) @"Tahoma", 30, NULL);
  return [LetterLayer layerWithLetter: letter usingFont: font];
}

+ (id) layerWithLetter: (NSString*) letter usingFont: (CTFontRef) font {
  LetterLayer* layer = [LetterLayer layer];
  [layer setLetter: letter];
  [layer setFont: font];
  [layer setForegroundColor: [Colors black]];
  layer.needsDisplayOnBoundsChange = YES;
  
  [layer setGlyphPaths: [[GlyphPaths alloc] initWithFont: font]];
  
  return layer;
}

- (id) init {
  id result = [super init];

  return result;
}

- (NSString*) letter {
  return letter;
}

- (void) setLetter: (NSString*) newLetter {
  letter = newLetter;
  [self setNeedsDisplay];
}

- (CTFontRef) font {
  return font;
}

- (void) setFont: (CTFontRef) newFont {
  font = newFont;
  [self setNeedsDisplay];
}


- (CGColorRef) foregroundColor {
  return foregroundColor;
}

- (void) setForegroundColor: (CGColorRef) newColor {
  foregroundColor = newColor;
}

- (void) drawInContext: (CGContextRef) context {
  CGContextSaveGState(context);
  
  CGPathRef quartzPath = [glyphPaths pathForLetter: letter];
  CGRect glyphBounds = CGPathGetBoundingBox(quartzPath);

  float scaleFactor = self.bounds.size.height / glyphBounds.size.height; 
  if (self.bounds.size.width < glyphBounds.size.width * scaleFactor) {
    scaleFactor = self.bounds.size.width / glyphBounds.size.width;
  }
  
  CGContextTranslateCTM(context, -glyphBounds.origin.x * scaleFactor, -glyphBounds.origin.y * scaleFactor);
  if (glyphBounds.size.height * scaleFactor < self.bounds.size.height) {
    CGContextTranslateCTM(context, 0, self.bounds.size.height - glyphBounds.size.height * scaleFactor);
  }
  
  
  CGContextScaleCTM(context, scaleFactor, scaleFactor);
  
  CGContextSetFillColorWithColor(context, foregroundColor);
  
  CGContextBeginPath(context);
  CGContextAddPath(context, quartzPath);
  CGContextClosePath(context);
  CGContextFillPath(context);
  
  CGContextRestoreGState(context);  
}


- (CGSize) preferredFrameSize {
  CGPathRef quartzPath = [glyphPaths pathForLetter: letter];
  CGRect glyphBounds = CGPathGetBoundingBox(quartzPath);
  return glyphBounds.size;
}


- (void)resizeWithOldSuperlayerSize:(CGSize)size {
  [CATransaction begin];
  [CATransaction setValue: [NSNumber numberWithBool: YES] forKey: kCATransactionDisableActions];
  
  CATransform3D transform = self.transform;
  self.transform = CATransform3DIdentity;
  
  [super resizeWithOldSuperlayerSize: size];
  
  self.transform = transform;
  
  [CATransaction commit];
}

- (void) setGlyphPaths: (GlyphPaths*) newGlyphPaths {
  glyphPaths = newGlyphPaths;
}


@end
