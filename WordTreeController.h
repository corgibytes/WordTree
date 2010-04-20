//
//  WordTreeController.h
//  WordTree
//
//  Created by M. Scott Ford on 2/18/08.
//  Copyright 2008 Corgibytes, LLC.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "LettersView.h"
#import "PathNames.h"
#import "PathPositions.h"


@interface WordTreeController : NSWindowController {
  IBOutlet WebView* lampView;
  IBOutlet LettersView* lettersView;
  
  NSMutableString* currentWord;
  
  PathNames* pathNames;
  PathPositions* pathPositions;
}

- (IBAction) openFile: (id) sender;

@end
