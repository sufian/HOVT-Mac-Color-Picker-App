//
//  ColorFormat.m
//  Color Picker
//

#import "ColorFormat.h"

@implementation ColorFormat

- (NSString *)formatFromColor:(NSColor *)color
{
  return nil;
}

- (NSString *)formatFromColor:(NSColor *)color withFormatString:(NSString *)formatString
{
  NSString* hexString = [NSString stringWithFormat:formatString, (int) (color.redComponent * 0xFF), (int) (color.greenComponent * 0xFF), (int) (color.blueComponent * 0xFF)];
  return hexString;
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"%@ (%@)", self.shortDescription, [self formatFromColor:[NSColor redColor]]];
}

@end
