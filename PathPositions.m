//
//  PathPositions.m
//  WordTree
//
//  Created by M. Scott Ford on 5/7/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "PathPositions.h"


@implementation PathPositions

- (id) initWithLampView: (WebView*) lampView {
  id result = [self init];
  if (result != nil) {
    script = [lampView windowScriptObject];
    positionCache = [[NSMutableDictionary alloc] init];
  }
  
  return result;
}

- (CGPoint) positionForPath: (NSString*) pathName {
  CGPoint result;
  
  NSValue* cachedValue = (NSValue*) [positionCache objectForKey: pathName];
  if (cachedValue == nil) {
    NSString* clientScript = [[NSString alloc] initWithFormat: @"getClientPositionOfPathElement('%@')", pathName];
    WebScriptObject* point = [script evaluateWebScript: clientScript];
    
    NSNumber* xValue = [point valueForKey: @"x"];
    float x = [xValue floatValue];
    NSNumber* yValue = [point valueForKey: @"y"];
    float y = [yValue floatValue];
    result = CGPointMake(x, y);
    
    [positionCache setValue: [NSValue valueWithPoint: result] forKey: pathName];
  }
  else {
    result = [cachedValue pointValue];
  }
  
  return result;
}

- (void) clearCache {
  [positionCache removeAllObjects];
}

@end
