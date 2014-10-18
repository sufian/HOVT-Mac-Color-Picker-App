//
//  Hex2Format.m
//  Color Picker
//

#import "Hex2Format.h"
#import "Constants.h"

@implementation Hex2Format

- (NSString *)formatFromColor:(NSColor *)color
{
  NSColor *rgbColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [super formatFromColor:rgbColor withFormatString:@"%02X%02X%02X"];
}

- (NSString *)shortDescription
{
  return kHex2ColorFormatShortDisplayedName;
}

@end
