//
//  ColorPickerWindow.m
//  Color Picker
//

#import "ColorPickerWindow.h"
#import "NSScreen+CarbonCoordinate.h"
#import "MagnifierView.h"
#import "Constants.h"
#import "ColorFormat.h"
#import "SelectedColorsManager.h"
#import <QuartzCore/QuartzCore.h>

#import "ApplicationDelegate.h"

@implementation ColorPickerWindow {
  id _mouseMovementMonitor;
  MagnifierView *_magnifierView;
}

- (void)dealloc
{
  if (_mouseMovementMonitor) {
    [NSEvent removeMonitor:_mouseMovementMonitor];
  }
}

- (void)awakeFromNib
{
  [self setReleasedWhenClosed:NO];
  [self setMovableByWindowBackground:NO];
  [self setBackgroundColor:[NSColor clearColor]];
  [self setLevel:(NSFloatingWindowLevel + 3000)];
  [self setOpaque:NO];
  [self setHasShadow:NO];
  
  CGRect frame = self.frame;
  frame.size = CGSizeMake(kAreaPixelCount * kZoomLevel, kAreaPixelCount * kZoomLevel);
  [self setFrame:frame display:NO];
  
  _mouseMovementMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent * mouseEvent) {
    if ([self isVisible]) {
      if (CGCursorIsVisible()) {
        [NSCursor hide];
      }
      [self updateWindow];
    }
  }];
  
  _magnifierView = [[MagnifierView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
  
  [self.contentView addSubview:_magnifierView];
  
  [self updateWindow];
}

- (void)updateWindow
{
  [_magnifierView updateMagnifiedImage];
  
  NSPoint point = [NSEvent mouseLocation];
  [self setFrameOrigin:NSMakePoint(point.x - (kAreaPixelCount * kZoomLevel / 2), point.y - (kAreaPixelCount * kZoomLevel / 2))];
}

- (void)mouseUp:(NSEvent *)theEvent
{
  [super mouseUp:theEvent];
  
  //NSLog(@"mouse up");
  CGFloat backingScaleFactor = [NSScreen mainScreen].backingScaleFactor;
  
  NSImage *magnifiedImage = [_magnifierView image];
  if (magnifiedImage) {
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:[magnifiedImage TIFFRepresentation]];
    NSSize imageSize = [magnifiedImage size];
    CGFloat x = floorf(imageSize.width / 2 / backingScaleFactor);
    CGFloat y = floorf(imageSize.height / 2 / backingScaleFactor);
    
    NSColor *selectedColor = [imageRep colorAtX:x y:y];
    ApplicationDelegate *delegate = (ApplicationDelegate *)[NSApp delegate];
    [delegate.selectedColorsManager addSelectedColor:selectedColor];
    
    NSSound *sound = [NSSound soundNamed:@"Pop"];
    [sound play];
    
    //NSLog(@"Selected colors: %@", [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType]);
  }
  [self orderOut:NSApp];
  [NSApp hide:NSApp];
}

- (void)cancelOperation:(id)sender
{
  //NSLog(@"Canceling");
  [super cancelOperation:sender];
  
  [self orderOut:NSApp];
  [NSApp hide:NSApp];
}

- (void)makeKeyAndOrderFront:(id)sender
{
  //NSLog(@"made key");
  [super makeKeyAndOrderFront:sender];
  
  [self updateWindow];
  [self becomeKeyWindow];
}

- (BOOL)canBecomeKeyWindow
{
  return YES;
}

- (BOOL)canBecomeMainWindow
{
  return YES;
}

- (void)becomeKeyWindow
{
  [super becomeKeyWindow];
  
  //NSLog(@"become key");
  
  if (CGCursorIsVisible()) {
    [NSCursor hide];
  }
}

- (void)resignKeyWindow
{
  //NSLog(@"resign key");
  
  if (!CGCursorIsVisible()) {
    [NSCursor unhide];
  }
  
  [self orderOut:NSApp];
  [NSApp hide:NSApp];
  
  [super resignKeyWindow];
}

@end
