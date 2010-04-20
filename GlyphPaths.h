//
//  GlyphPaths.h
//  WordTree
//
//  Created by M. Scott Ford on 5/24/08.
//  Copyright 2008 __MyCompanyName__. 
//

#import <Cocoa/Cocoa.h>


@interface GlyphPaths : NSObject {
  CTFontRef font;
  NSMutableDictionary* pathCache;
}

- (id) initWithFont: (CTFontRef) font;

- (CGPathRef) pathForLetter: (NSString*) letter;

@end
