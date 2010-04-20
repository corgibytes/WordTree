//
//  PathPositions.h
//  WordTree
//
//  Created by M. Scott Ford on 5/7/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PathPositions : NSObject {
  WebScriptObject* script;
  
  NSMutableDictionary* positionCache;
}

- (id) initWithLampView: (WebView*) lampView;
- (CGPoint) positionForPath: (NSString*) pathName;
- (void) clearCache;

@end
