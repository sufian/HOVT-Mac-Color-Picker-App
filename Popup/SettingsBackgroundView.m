//
//  SettingsBackgroundView.m
//  Popup
//

#import "SettingsBackgroundView.h"
#import "NSColor+ColorConstants.h"
#import "VerticalAlignedTextLabel.h"
#import "NSFont+OpenSans.h"

#import <ServiceManagement/ServiceManagement.h>

#define RADIUS 10.0f

NSInteger kShortcutLabelWidth = 100;
NSInteger kShortcutLabelHeight = 32;
NSInteger kShortcutLabelTopGap = 40;

NSInteger kSeparatorEdgeGap = 20;

NSInteger kCheckboxWidth = 150;
NSInteger kCheckboxBottomGap = 18;
NSInteger kCheckboxHeight = 30;

NSString *kShortcutTitle = @"Shortcut";
NSString *kCheckboxTitle = @"Launch at login";

static NSString *loginHelperBundleId = @"draftbeta.HOVT-Login-Helper";
static NSString *kLaunchAtLoginUserDefaultsKey = @"draftbeta.HOVT.launchAtLogin";

@implementation SettingsBackgroundView {
  VerticalAlignedTextLabel *_shortcutLabel;
  NSButton *_launchAtLoginButton;
}

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _shortcutLabel = [[VerticalAlignedTextLabel alloc] initWithFrame:NSMakeRect((frame.size.width - kShortcutLabelWidth) / 2, NSMaxY(self.bounds) - kShortcutLabelTopGap, kShortcutLabelWidth, kShortcutLabelHeight)];
    _shortcutLabel.alignment = NSCenterTextAlignment;
    _shortcutLabel.font = [NSFont openSansSemiBoldOfSize:16];
    _shortcutLabel.stringValue = NSLocalizedString(kShortcutTitle, nil);
    
    [self addSubview:_shortcutLabel];
    
    _launchAtLoginButton = [[NSButton alloc] initWithFrame:NSMakeRect((frame.size.width - kCheckboxWidth) / 2, kCheckboxBottomGap, kCheckboxWidth, kCheckboxHeight)];
    [_launchAtLoginButton setButtonType:NSSwitchButton];
    _launchAtLoginButton.font = [NSFont openSansSemiBoldOfSize:16];
    _launchAtLoginButton.title = [NSString stringWithFormat:@"  %@", NSLocalizedString(kCheckboxTitle, nil)];
    _launchAtLoginButton.target = self;
    _launchAtLoginButton.action = @selector(toggleLaunchAtLogin);
    
    BOOL launchAtLogin =  [[NSUserDefaults standardUserDefaults] boolForKey:kLaunchAtLoginUserDefaultsKey];
    self.launchAtLoginButton.state = launchAtLogin ? NSOnState : NSOffState;
    
    [self addSubview:_launchAtLoginButton];
  }
  
  return self;
}

- (NSButton *)launchAtLoginButton
{
  return _launchAtLoginButton;
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), RADIUS)];
  [path curveToPoint:NSMakePoint(NSMaxX(self.bounds) - RADIUS, NSMinY(self.bounds)) controlPoint1:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds)) controlPoint2:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
  [path lineToPoint:NSMakePoint(NSMinX(self.bounds) + RADIUS, NSMinY(self.bounds))];
  [path curveToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds) + RADIUS) controlPoint1:self.bounds.origin controlPoint2:self.bounds.origin];
  [path closePath];
  
  [[NSColor whiteColor] setFill];
  [path fill];
  
  [[NSColor selectedColorViewTopSeparator] setStroke];
  [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
  
  [[NSColor selectedColorViewTopSeparator] setStroke];
  CGFloat separatorY = self.bounds.size.height * 2.0 / 5.0 + NSMinY(self.bounds);
  [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds) + kSeparatorEdgeGap, separatorY) toPoint:NSMakePoint(NSMaxX(self.bounds) - kSeparatorEdgeGap, separatorY)];
  
  [super drawRect:dirtyRect];
}

- (void)toggleLaunchAtLogin
{
  if (self.launchAtLoginButton.state == NSOnState) { // ON
    // Turn on launch at login
    if (!SMLoginItemSetEnabled ((__bridge CFStringRef)loginHelperBundleId, YES)) {
      //      NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
      //                                       defaultButton:@"OK"
      //                                     alternateButton:nil
      //                                         otherButton:nil
      //                           informativeTextWithFormat:@"Couldn't add Helper App to launch at login item list."];
      
      NSLog(@"Couldn't add Helper App to launch at login item list.");
      
      //[alert runModal];
    } else {
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLaunchAtLoginUserDefaultsKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
      NSLog(@"Successfully installed Helper App to launch at login item list.");
    }
  } else { // OFF
    // Turn off launch at login
    if (!SMLoginItemSetEnabled ((__bridge CFStringRef)loginHelperBundleId, NO)) {
      //      NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
      //                                       defaultButton:@"OK"
      //                                     alternateButton:nil
      //                                         otherButton:nil
      //                           informativeTextWithFormat:@"Couldn't remove Helper App from launch at login item list."];
      
      NSLog(@"Couldn't remove Helper App from launch at login item list.");
      
      //[alert runModal];
    } else {
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLaunchAtLoginUserDefaultsKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
      NSLog(@"Successfully remove Helper App from launch at login item list.");
    }
  }
}

@end
