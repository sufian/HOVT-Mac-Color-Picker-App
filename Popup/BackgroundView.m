#import "BackgroundView.h"
#import "NSColor+ColorConstants.h"

#define FILL_OPACITY 1.0f
#define STROKE_OPACITY 1.0f

#define LINE_THICKNESS 1.0f
#define CORNER_RADIUS 10.0f

#pragma mark -

@implementation BackgroundView

@synthesize arrowX = _arrowX;

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect
{
  //  NSRect contentRect = NSInsetRect([self bounds], LINE_THICKNESS, LINE_THICKNESS);
  NSRect contentRect = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPath];
  
  [path moveToPoint:NSMakePoint(_arrowX, NSMaxY(contentRect))];
  [path lineToPoint:NSMakePoint(_arrowX + ARROW_WIDTH / 2, NSMaxY(contentRect) - ARROW_HEIGHT)];
  [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - CORNER_RADIUS, NSMaxY(contentRect) - ARROW_HEIGHT)];
  
  NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - ARROW_HEIGHT);
  [path curveToPoint:NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - ARROW_HEIGHT - CORNER_RADIUS)
       controlPoint1:topRightCorner controlPoint2:topRightCorner];
  
  [path lineToPoint:NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + CORNER_RADIUS)];
  
  NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect));
  [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - CORNER_RADIUS, NSMinY(contentRect))
       controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
  
  [path lineToPoint:NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMinY(contentRect))];
  
  [path curveToPoint:NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + CORNER_RADIUS)
       controlPoint1:contentRect.origin controlPoint2:contentRect.origin];
  
  [path lineToPoint:NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - ARROW_HEIGHT - CORNER_RADIUS)];
  
  NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - ARROW_HEIGHT);
  [path curveToPoint:NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMaxY(contentRect) - ARROW_HEIGHT)
       controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
  
  [path lineToPoint:NSMakePoint(_arrowX - ARROW_WIDTH / 2, NSMaxY(contentRect) - ARROW_HEIGHT)];
  [path closePath];
  
  [[NSColor menuBackground] setFill];
  [path fill];
}

#pragma mark -
#pragma mark Public accessors

- (void)setArrowX:(NSInteger)value
{
  _arrowX = value;
  [self setNeedsDisplay:YES];
}

@end
