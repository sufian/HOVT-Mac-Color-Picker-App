//
//  RgbFormat.m
//  HOVT
//

#import "RgbFormat.h"

@implementation RgbFormat

- (NSString *)formatFromColor:(NSColor *)color
{
  NSColor *rgbColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [super formatFromColor:rgbColor withFormatString:@"RGB(%d, %d, %d)"];
}

- (NSString *)shortDescription
{
  return @"RGB";
}

@end
