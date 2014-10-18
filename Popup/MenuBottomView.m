//
//  MenuBottomView.m
//  Popup
//

#import "MenuBottomView.h"
#import "NSColor+ColorConstants.h"

#define RADIUS 10.0f

NSInteger kButtonToEdgeGap = 18;

@implementation MenuBottomView

@synthesize preferenceButton = _preferenceButton;
@synthesize exitButton = _exitButton;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    NSImage *preferenceIcon = [[NSBundle mainBundle] imageForResource:@"preference button"];
    _preferenceButton = [[NSButton alloc] initWithFrame:NSMakeRect(kButtonToEdgeGap, (self.bounds.size.height - preferenceIcon.size.height) / 2 - 3, preferenceIcon.size.width, preferenceIcon.size.height)];
    [_preferenceButton setButtonType:NSMomentaryChangeButton];
    [_preferenceButton setBordered:NO];
    _preferenceButton.imagePosition = NSImageOnly;
    _preferenceButton.image = preferenceIcon;
    
    [self addSubview:_preferenceButton];
    
    NSImage *exitIcon = [[NSBundle mainBundle] imageForResource:@"exit button"];
    _exitButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.bounds.size.width - kButtonToEdgeGap - exitIcon.size.width, (self.bounds.size.height - exitIcon.size.height) / 2 - 3, exitIcon.size.width, exitIcon.size.height)];
    [_exitButton setButtonType:NSMomentaryChangeButton];
    [_exitButton setBordered:NO];
    _exitButton.imagePosition = NSImageOnly;
    _exitButton.image = exitIcon;
    _exitButton.target = self;
    _exitButton.action = @selector(quitApp);
    
    [self addSubview:_exitButton];
  }
  
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSColor bottomMenuItem] setFill];
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), RADIUS)];
  [path curveToPoint:NSMakePoint(NSMaxX(self.bounds) - RADIUS, NSMinY(self.bounds)) controlPoint1:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds)) controlPoint2:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMinX(self.bounds) + RADIUS, NSMinY(self.bounds))];
  [path curveToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds) + RADIUS) controlPoint1:self.bounds.origin controlPoint2:self.bounds.origin];
  [path closePath];
  [path fill];
  
  [[NSColor topButtomMenuItemSeparator] setStroke];
  [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
}

- (void)quitApp
{
  [[NSUserDefaults standardUserDefaults] synchronize];
  [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
