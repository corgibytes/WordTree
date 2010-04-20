//
//  WordTreeController.m
//  WordTree
//
//  Created by M. Scott Ford on 2/18/08.
//  Copyright 2008 Corgibytes, LLC. 
//

#import "WordTreeController.h"

#import <QuartzCore/CoreAnimation.h>
#import <QuartzCore/CoreImage.h>
#import <WebKit/WebKit.h>
#import <Foundation/NSThread.h>

#import "Colors.h"
#import "LetterLayer.h"

@interface WordTreeController() 

- (void) writeOnTree: (NSString*) word;
- (void) dangleLetter: (NSString*) letter fromTreeNodePath: (NSString*) pathName;
- (CIVector*) redComponentVectorForColor: (CGColorRef) color;
- (CIVector*) greenComponentVectorForColor: (CGColorRef) color;
- (CIVector*) blueComponentVectorForColor: (CGColorRef) color;
- (CIVector*) multiplyArray: (const CGFloat*) first 
                    byArray: (const CGFloat*) second 
                      count: (int) count;
- (CAAnimation*) colorChangeAnimation: (CGColorRef) color;
- (CAAnimation*) letterHangAnimationForLayer: (CALayer*) letterLayer withPreferredSize: (CGSize) preferredSize;
- (float) getRandomAngle;

- (void) displayFileContents: (NSString*) contents;
- (void) openFileWithFilename: (NSString*) filename;

@end

@implementation WordTreeController

- (void) awakeFromNib {
  [[self window] setDelegate: self];
  [[[lampView mainFrame] frameView] setAllowsScrolling: NO];
  
  NSString* lampFilePath = [[NSBundle mainBundle] pathForResource: @"lamp.xhtml" ofType: nil];
  NSURL* url = [[NSURL alloc] initFileURLWithPath: lampFilePath];
  NSURLRequest* request = [[NSURLRequest alloc] initWithURL: url];
  [lampView setFrameLoadDelegate: self];
  [[lampView mainFrame] loadRequest: request];
  
  CALayer* layer = [CALayer layer];
  layer.backgroundColor = [Colors clear];
  layer.delegate = self;
  [lettersView setLayer: layer];
  [lettersView setWantsLayer: YES];  
  
  currentWord = [[NSMutableString alloc] init];
  
  pathNames = [[PathNames alloc] init];
  pathPositions = [[PathPositions alloc] initWithLampView: lampView];
}

- (void) writeOnTree: (NSString*) word {
  int count = MIN([pathNames count], [word length]);
  int letterIndex;
  int pathIndex = MAX([pathNames count], [word length]) / 2 - count / 2;
  if ([word length] > [pathNames count]) {
    pathIndex = 0;
  }
  
  for (letterIndex = 0; letterIndex < [word length] && pathIndex < [pathNames count]; letterIndex++) {
    NSString* letter = [word substringWithRange: NSMakeRange(letterIndex, 1)];
    [self dangleLetter: letter fromTreeNodePath: [pathNames pathNameAtIndex: pathIndex]];
    pathIndex++;
  }
}

- (void) dangleLetter: (NSString*) letter fromTreeNodePath: (NSString*) pathName {  
  CGPoint pathPosition = [pathPositions positionForPath: pathName];
  float x = pathPosition.x;
  float y = pathPosition.y;
  float viewHeight = lettersView.layer.bounds.size.height;
  LetterLayer* letterLayer = [LetterLayer layerWithLetter: letter];
  [lettersView.layer addSublayer: letterLayer]; 
  letterLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMaxXMargin | kCALayerMaxYMargin | kCALayerMinXMargin | kCALayerMinYMargin;

  CGSize preferredSize = [letterLayer preferredFrameSize];
  float scaleFactor = viewHeight / 300;
  preferredSize = CGSizeMake(fmaxf(preferredSize.width * scaleFactor, 1.0), 
                             fmaxf(preferredSize.height * scaleFactor, 1.0));
  
  CGAffineTransform coordinateTransform = 
    CGAffineTransformConcat(CGAffineTransformMakeScale(1, -1), 
                            CGAffineTransformMakeTranslation(0, viewHeight));
  CGPoint hangPoint = CGPointApplyAffineTransform(CGPointMake(x, y), 
                                                  coordinateTransform);
                                                  
  CGRect frameRect = CGRectMake(hangPoint.x, hangPoint.y - preferredSize.height, 
                                preferredSize.width, preferredSize.height);
    
  letterLayer.anchorPoint = NSMakePoint(0, 1);
  letterLayer.frame = frameRect;
  letterLayer.foregroundColor = [Colors white];
  
  CIFilter* colorFilter = [CIFilter filterWithName: @"CIWhitePointAdjust"];
  colorFilter.name = @"colorFilter";
  [colorFilter setDefaults];
  [colorFilter setValue: [CIColor colorWithCGColor: [Colors darkGreen]]
                 forKey: @"inputColor"];
                   
  NSArray* filters = [NSArray arrayWithObject: colorFilter];
  letterLayer.filters = filters;
  
  float angle = [self getRandomAngle];
  letterLayer.transform = CATransform3DMakeRotation(-angle, 0, 0, 1);
    
  // grow animation  
  CAAnimation* letterHangAnimation = [self letterHangAnimationForLayer: letterLayer withPreferredSize: preferredSize];
  [letterLayer addAnimation: letterHangAnimation forKey: @"letterHang"];

}

- (void) keyUp: (NSEvent*) event {
  if ([event keyCode] == 36) {
    [self writeOnTree: currentWord];
    [currentWord deleteCharactersInRange: NSMakeRange(0, [currentWord length])];
  } else {
    [currentWord appendString: [event characters]];
  }
}

- (CIVector*) redComponentVectorForColor: (CGColorRef) color {
  CGFloat identityValues[4] = {1, 0, 0, 0};
  return [self multiplyArray: identityValues byArray: CGColorGetComponents(color) count: 4];
}

- (CIVector*) greenComponentVectorForColor: (CGColorRef) color {
  CGFloat identityValues[4] = {0, 1, 0, 0};
  return [self multiplyArray: identityValues byArray: CGColorGetComponents(color) count: 4];  
}

- (CIVector*) blueComponentVectorForColor: (CGColorRef) color {
  CGFloat identityValues[4] = {0, 0, 1, 0};
  return [self multiplyArray: identityValues byArray: CGColorGetComponents(color) count: 4];    
}

- (CIVector*) multiplyArray: (const CGFloat*) first byArray: (const CGFloat*) second count: (int) count {
  CGFloat resultValues[count];
  
  int index;
  for (index = 0; index < count; index++) {
    resultValues[index] = first[index] * second[index];
  }
  
  return [CIVector vectorWithValues: resultValues count: count];
}

- (CAAnimation*) colorChangeAnimation: (CGColorRef) color { 
  CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath: @"filters.colorFilter.inputColor"];
  animation.toValue = [CIColor colorWithCGColor: color];
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  return animation;
}

- (CAAnimation*) letterHangAnimationForLayer: (CALayer*) letterLayer withPreferredSize: (CGSize) preferredSize {
  CAAnimationGroup* parentAnimationGroup = [CAAnimationGroup animation];
  parentAnimationGroup.fillMode = kCAFillModeForwards;
  parentAnimationGroup.removedOnCompletion = NO;
  
  CABasicAnimation* scaleUpAnimation = [CABasicAnimation animationWithKeyPath: @"bounds.size"];
  scaleUpAnimation.fromValue = [NSValue valueWithSize: CGSizeMake(0, 0)];
  scaleUpAnimation.toValue = [NSValue valueWithSize: preferredSize];
  scaleUpAnimation.duration = 2;
  scaleUpAnimation.fillMode = kCAFillModeForwards;
  scaleUpAnimation.removedOnCompletion = NO;

  CAAnimation* orangeColorChangeAnimation = [self colorChangeAnimation: [Colors orange]];
  orangeColorChangeAnimation.beginTime = 2;
  orangeColorChangeAnimation.duration = 1;  
  
  CAAnimation* maroonColorChangeAnimation = [self colorChangeAnimation: [Colors maroon]];
  maroonColorChangeAnimation.beginTime = 3;
  maroonColorChangeAnimation.duration = 2;    
  
  CAAnimation* brownColorChangeAnimation = [self colorChangeAnimation: [Colors darkBrown]];
  brownColorChangeAnimation.beginTime = 4;
  brownColorChangeAnimation.duration = 1;
  
  CAAnimation* blackColorChangeAnimation = [self colorChangeAnimation: [Colors black]];
  blackColorChangeAnimation.beginTime = 6;
  blackColorChangeAnimation.duration = 2;
  
  float fallStart = random() % 6 / 10.0f + 1.5;
  float fallDuration = random() % 10 / 10.0f + 1;
  
  CABasicAnimation* fallAnimation = [CABasicAnimation animationWithKeyPath: @"position.y"];
  fallAnimation.toValue = [NSNumber numberWithFloat: letterLayer.frame.size.height];
  srandomdev();
  fallAnimation.beginTime = fallStart;
  fallAnimation.duration = fallDuration;
  fallAnimation.fillMode = kCAFillModeForwards;
  fallAnimation.removedOnCompletion = NO;

  float shrinkFactor = random() % 10 / 10.0f + 1.0f;
  CABasicAnimation* shrinkAnimation = [CABasicAnimation animationWithKeyPath: @"bounds.size"];
  shrinkAnimation.fromValue = [NSValue valueWithSize: preferredSize];
  shrinkAnimation.toValue = [NSValue valueWithSize: CGSizeMake(preferredSize.width / shrinkFactor, 
                                                               preferredSize.height / shrinkFactor)];
  shrinkAnimation.beginTime = fallStart;
  shrinkAnimation.duration = fallDuration;
  shrinkAnimation.fillMode = kCAFillModeForwards;
  shrinkAnimation.removedOnCompletion = NO;
  
  CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
  rotateAnimation.toValue = [NSNumber numberWithFloat: [self getRandomAngle]];
  rotateAnimation.beginTime = fallStart;
  rotateAnimation.duration = fallDuration / 2.0f;
  rotateAnimation.autoreverses = YES;
  rotateAnimation.fillMode = kCAFillModeBoth;
  rotateAnimation.removedOnCompletion = YES;
  
  CABasicAnimation* driftAnimation = [CABasicAnimation animationWithKeyPath: @"position.x"];
  driftAnimation.toValue = [NSNumber numberWithFloat: letterLayer.frame.origin.x + random() % 4 / 2.0f - 1.0f];
  driftAnimation.beginTime = fallStart;
  driftAnimation.duration = fallDuration;
  driftAnimation.fillMode = kCAFillModeForwards;
  driftAnimation.removedOnCompletion = NO;
  
  CABasicAnimation* fadeoutAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
  fadeoutAnimation.toValue = [NSNumber numberWithFloat: 0];
  fadeoutAnimation.beginTime = fallStart + fallDuration + 3;
  fadeoutAnimation.duration = 3;
  fadeoutAnimation.fillMode = kCAFillModeForwards;
  fadeoutAnimation.removedOnCompletion = NO;
    
  NSArray* animations = [NSArray arrayWithObjects: scaleUpAnimation, 
   orangeColorChangeAnimation, maroonColorChangeAnimation,
   brownColorChangeAnimation, blackColorChangeAnimation, 
   fallAnimation, shrinkAnimation, rotateAnimation, driftAnimation, 
   fadeoutAnimation, nil];
  
  float finalStart = 0;
  float finalDuration = 0;
  
  for (CAAnimation* animation in animations) {
    if ((animation.beginTime + animation.duration) > (finalStart + finalDuration)) {
      finalStart = animation.beginTime;
      finalDuration = animation.duration;
    }
  }
  
  parentAnimationGroup.duration = finalStart + finalDuration;
  parentAnimationGroup.delegate = self;
  
  [parentAnimationGroup setValue: letterLayer forKey: @"parentLayer"];
  
  parentAnimationGroup.animations = animations;
  return parentAnimationGroup;
}

- (void) animationDidStop: (CAAnimation *) theAnimation finished: (BOOL) flag {
  CALayer* parentLayer = [theAnimation valueForKey: @"parentLayer"];
  [parentLayer removeFromSuperlayer];
}

- (float) getRandomAngle {
  int minDegree = -50;
  int maxDegree = 50;
  srandomdev();
  float randomDegree = (random() % (maxDegree - minDegree)) + minDegree;
  float randomRadian = randomDegree * 3.141592654f / 180.0f;
  return randomRadian;
}

- (IBAction) openFile: (id) sender {
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  NSArray *fileTypes = [NSArray arrayWithObjects: @"txt", @"text",
                        NSFileTypeForHFSTypeCode( 'TEXT' ), nil];
  if ([openPanel runModalForTypes: fileTypes] == NSOKButton) {      
    [self openFileWithFilename: [openPanel filename]];
      
    NSDocumentController* controller = [[NSDocumentController alloc] init];
    [controller noteNewRecentDocumentURL: [openPanel URL]];  
  }
}

- (BOOL) application: (NSApplication*) theApplication openFile: (NSString*) filename {
  [self openFileWithFilename: filename];
  return YES;
}

- (void) openFileWithFilename: (NSString*) filename {
  NSString* contents = [NSString stringWithContentsOfFile: filename encoding: NSUTF8StringEncoding error: nil];
  
  [self performSelectorInBackground: @selector(displayFileContents:) withObject: contents];
}

- (void) displayFileContents: (NSString*) contents {
  NSArray* components = [contents componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  int index = 0;
  while (index < [components count]) {
    NSString* word = [components objectAtIndex: index];
    NSString* nextWord = nil;
    if (index + 1 < [components count]) {
      nextWord = [components objectAtIndex: index + 1];
    }
    
    while ((nextWord != nil) && (([word length] + [nextWord length] + 1 < [pathNames count]))) {
      index++;
      word = [[NSArray arrayWithObjects: word, nextWord, nil] componentsJoinedByString: @" "];      
      
      nextWord = nil;
      if (index + 1 < [components count]) {
        nextWord = [components objectAtIndex: index + 1];
      }      
    }
    
    float delay = 3.2;
    if (index == 0) {
      delay = 0;
    }

    [self performSelectorOnMainThread: @selector(writeOnTree:) withObject: word waitUntilDone: NO];
    [NSThread sleepForTimeInterval: delay];
    index++;
  }  
}

- (NSSize) windowWillResize: (NSWindow*) window toSize: (NSSize) proposedFrameSize {
  [pathPositions clearCache];

  return proposedFrameSize;
}

@end
