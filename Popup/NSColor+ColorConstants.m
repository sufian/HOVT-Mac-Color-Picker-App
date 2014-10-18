//
//  NSColor+ColorConstants.m
//  Popup
//

#import "NSColor+ColorConstants.h"

@implementation NSColor (ColorConstants)

+ (NSColor *)menuBackground
{
  static NSColor *_menuBackground = nil;
  if (!_menuBackground) {
    _menuBackground = [NSColor colorWithCalibratedRed:244.0 / 255 green:244.0 / 255 blue:244.0 / 255 alpha:1];
  }
  return _menuBackground;
}

+ (NSColor *)topMenuItemButtom
{
  static NSColor *_topMenuItemButtom = nil;
  if (!_topMenuItemButtom) {
    _topMenuItemButtom = [NSColor colorWithCalibratedRed:229.0 / 255 green:229.0 / 255 blue:229.0 / 255 alpha:1];
  }
  return _topMenuItemButtom;
}

+ (NSColor *)topButtomMenuItemSeparator
{
  static NSColor *_topButtomMenuItemSeparator = nil;
  if (!_topButtomMenuItemSeparator) {
    _topButtomMenuItemSeparator = [NSColor colorWithCalibratedRed:192.0 / 255 green:192.0 / 255 blue:192.0 / 255 alpha:1];
  }
  return _topButtomMenuItemSeparator;
}

+ (NSColor *)selectedColorViewHighlight
{
  static NSColor *_selectedColorViewHighlight = nil;
  if (!_selectedColorViewHighlight) {
    _selectedColorViewHighlight = [NSColor colorWithCalibratedRed:235.0 / 255 green:250.0 / 255 blue:255.0 / 255 alpha:1];
  }
  return _selectedColorViewHighlight;
}

+ (NSColor *)selectedColorViewTopSeparator
{
  static NSColor *_selectedColorViewTopSeparator = nil;
  if (!_selectedColorViewTopSeparator) {
    _selectedColorViewTopSeparator = [NSColor colorWithCalibratedRed:232.0 / 255 green:232.0 / 255 blue:232.0 / 255 alpha:1];
  }
  return _selectedColorViewTopSeparator;
}

+ (NSColor *)bottomMenuItem
{
  static NSColor *_bottomMenuItem = nil;
  if (!_bottomMenuItem) {
    _bottomMenuItem = [NSColor colorWithCalibratedRed:242.0 / 255 green:242.0 / 255 blue:242.0 / 255 alpha:1];
  }
  return _bottomMenuItem;
}

@end
