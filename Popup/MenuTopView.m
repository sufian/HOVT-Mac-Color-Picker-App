//
//  MenuTopView.m
//  Popup
//

#import "MenuTopView.h"
#import "NSColor+ColorConstants.h"

#define RADIUS 10.0f

@implementation MenuTopView {
  NSImage *_logoImage;
}

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    _logoImage = [[NSBundle mainBundle] imageForResource:@"top menu item"];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds) - RADIUS)];
  [path curveToPoint:NSMakePoint(NSMinX(self.bounds) + RADIUS, NSMaxY(self.bounds)) controlPoint1:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds)) controlPoint2:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds) - RADIUS, NSMaxY(self.bounds))];
  [path curveToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds) - RADIUS) controlPoint1:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds)) controlPoint2:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds))];
  [path closePath];
  
  NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor topMenuItemButtom] endingColor:[NSColor menuBackground]];
  [gradient drawInBezierPath:path angle:90];
  
  [[NSColor topButtomMenuItemSeparator] setStroke];
  [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
  
  [_logoImage drawAtPoint:NSMakePoint(floorf((self.bounds.size.width - _logoImage.size.width) / 2), floorf((self.bounds.size.height - _logoImage.size.height) / 2) + 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
  
  [super drawRect:dirtyRect];
}

@end
