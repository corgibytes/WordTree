//
//  Colors.m
//  WordTree
//
//  Created by M. Scott Ford on 2/20/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "Colors.h"


@implementation Colors


+ (CGColorRef) clear {
  static CGColorRef clear = NULL;
  if (clear == NULL) {
    CGFloat clearValues[4] = {0.0, 0.0, 0.0, 0.0}; 
    clear = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), clearValues);  
  }
  return clear;
}

+ (CGColorRef) darkGreen {
  static CGColorRef green = NULL;
  if (green == NULL) {
    CGFloat greenValues[4] = {0.0, 107.0f / 255.0f, 41.0f / 255.0f, 1.0}; 
    green = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), greenValues);  
  }
  return green;  
}

+ (CGColorRef) orange {
  CGFloat orangeValues[4] = {177.0f / 255.0f, 77.0f / 255.0f, 21.0f / 255.0f, 1.0}; 
  CGColorRef orange = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), orangeValues);  
  return orange;  
}

+ (CGColorRef) maroon {
  static CGColorRef maroon = NULL;
  if (maroon == NULL) {
    CGFloat maroonValues[4] = {110.0f / 255.0f, 52.0f / 255.0f, 22.0f / 255.0f, 1.0}; 
    maroon = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), maroonValues);  
  }
  return maroon;  
}

+ (CGColorRef) darkBrown {
  static CGColorRef darkBrown = NULL;
  if (darkBrown == NULL) {
    CGFloat darkBrownValues[4] = {80.0f / 255.0f, 41.0f / 255.0f, 20.0f / 255.0f, 1.0}; 
    darkBrown = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), darkBrownValues);  
  }
  return darkBrown;  
}

+ (CGColorRef) black {
  static CGColorRef black = NULL;
  if (black == NULL) {
    CGFloat values[4] = {0.0, 0.0, 0.0, 1.0}; 
    black = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), values);      
  }
  return black;
}

+ (CGColorRef) white {
  static CGColorRef white = NULL;
  if (white == NULL) {
    CGFloat values[4] = { 1.0, 1.0, 1.0, 1.0 };
    white = CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), values);
  }
  return white;
}

+ (CGColorRef) fromColor: (NSColor*) color {
  NSColor* deviceColor = [color colorUsingColorSpaceName: NSDeviceRGBColorSpace];
  
  float components[4];
  [deviceColor getRed: &components[0] green: &components[1] blue: &components[2] alpha: &components[3]];

  return CGColorCreate(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), components);
}




@end
