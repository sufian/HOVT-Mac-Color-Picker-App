//
//  CmykFormat.m
//  Color Picker
//

#import "CmykFormat.h"
#import "Constants.h"

@implementation CmykFormat

- (NSString *)formatFromColor:(NSColor *)color
{
  NSColor *cmykColor = [color colorUsingColorSpaceName:NSDeviceCMYKColorSpace];
  NSString *cmykString = [NSString stringWithFormat:@"%d, %d, %d, %d", (int) (cmykColor.cyanComponent * 0xFF), (int) (cmykColor.magentaComponent * 0xFF), (int) (cmykColor.yellowComponent * 0xFF), (int) (cmykColor.blackComponent * 0xFF)];
  return cmykString;
}

- (NSString *)shortDescription
{
  return kCmykColorFormatShortDisplayedName;
}

@end
