//
//  HexFormat.m
//  Color Picker
//

#import "HexFormat.h"
#import "Constants.h"

@implementation HexFormat

- (NSString *)formatFromColor:(NSColor *)color
{
  NSColor *rgbColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [super formatFromColor:rgbColor withFormatString:@"#%02X%02X%02X"];
}

- (NSString *)shortDescription
{
  return kHexColorFormatShortDisplayedName;
}

@end
