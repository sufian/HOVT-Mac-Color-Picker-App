//
//  CircularImageView.m
//  Color Picker
//

#import "MagnifierView.h"
#import "NSScreen+CarbonCoordinate.h"
#import "Constants.h"

@implementation MagnifierView {
  CGContextRef _magnifierViewContentContext;
  NSBezierPath *_ringPath, *_centerSquarePath;
}

- (void)dealloc
{
  if (_magnifierViewContentContext) {
    CGContextRelease(_magnifierViewContentContext);
  }
}

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setWantsLayer:YES];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];
  
  [[NSColor darkGrayColor] setStroke];
  [[NSColor whiteColor] setFill];
  [_ringPath stroke];
  [_ringPath fill];
  
  [[NSColor darkGrayColor] setStroke];
  [_centerSquarePath stroke];
}

- (void)updateMagnifiedImage
{
  CGFloat backingScaleFactor = [NSScreen mainScreen].backingScaleFactor;
  if (_magnifierViewContentContext) {
    CGContextRelease(_magnifierViewContentContext);
    _magnifierViewContentContext = nil;
  }
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  _magnifierViewContentContext = CGBitmapContextCreate (NULL, kAreaPixelCount * kZoomLevel / backingScaleFactor, kAreaPixelCount * kZoomLevel / backingScaleFactor, 8, 0, colorSpaceRef, kCGImageAlphaNoneSkipFirst);
  CGColorSpaceRelease(colorSpaceRef);
  CGContextSetInterpolationQuality(_magnifierViewContentContext, kCGInterpolationNone);
  
  _ringPath = [NSBezierPath new];
  [_ringPath setWindingRule:NSEvenOddWindingRule];
  [_ringPath appendBezierPathWithOvalInRect:CGRectInset(self.bounds, 1, 1)];
  [_ringPath appendBezierPathWithOvalInRect:CGRectInset(self.bounds, 5, 5)];
  _ringPath.lineWidth = 1;
  
  NSRect centerRect = NSMakeRect((floorf(kAreaPixelCount / 2)) * kZoomLevel , (floorf(kAreaPixelCount / 2)) * kZoomLevel, kZoomLevel, kZoomLevel);
  _centerSquarePath = [NSBezierPath bezierPathWithRect:centerRect];
  _centerSquarePath.lineWidth = 2;
  
  CGWindowID windowId = (CGWindowID)[[self window] windowNumber];
  
  CGPoint cgPoint = [NSScreen carbonPointFrom:[NSEvent mouseLocation]];
  CGRect rect = CGRectMake(cgPoint.x - floor(kAreaPixelCount / 2), cgPoint.y - floor(kAreaPixelCount / 2), kAreaPixelCount, kAreaPixelCount);
  CGImageRef imageRef = CGWindowListCreateImage(rect, kCGWindowListOptionOnScreenBelowWindow, windowId, kCGWindowImageBoundsIgnoreFraming);
  CGContextDrawImage(_magnifierViewContentContext, NSMakeRect(0, 0, kAreaPixelCount * kZoomLevel, kAreaPixelCount * kZoomLevel), imageRef);
  CGImageRef scaledImageRef = CGBitmapContextCreateImage(_magnifierViewContentContext);
  
  NSImage *image = [[NSImage alloc] initWithCGImage:scaledImageRef size:NSMakeSize(kAreaPixelCount * kZoomLevel, kAreaPixelCount * kZoomLevel)];
  
  CGImageRelease(imageRef);
  CGImageRelease(scaledImageRef);
  
  [self setImage:image];
}

@end
