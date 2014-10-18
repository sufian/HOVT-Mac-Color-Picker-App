//
//  RgbFormat.m
//  Color Picker
//

#import "RgbaFormat.h"
#import "Constants.h"

@implementation RgbaFormat

- (NSString *)formatFromColor:(NSColor *)color
{
  NSColor *rgbColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [super formatFromColor:rgbColor withFormatString:@"rgba(%d, %d, %d, 1)"];
}

- (NSString *)shortDescription
{
  return kRgbaColorFormatShortDisplayedName;
}

@end
