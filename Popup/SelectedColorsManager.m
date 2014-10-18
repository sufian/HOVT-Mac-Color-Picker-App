//
//  SelectedColorsManager.m
//  Color Picker
//

#import "SelectedColorsManager.h"
#import "Constants.h"
#import "ColorFormat.h"
#import "Hex2Format.h"
#import "HexFormat.h"
#import "RgbaFormat.h"
#import "CmykFormat.h"
#import "RgbFormat.h"

@implementation SelectedColorsManager {
  NSMutableArray *_selectedColors;
}

@synthesize selectedColors = _selectedColors, colorFormatIndex = _colorFormatIndex, colorFormats = _colorFormats;

- (id)init;
{
  self = [super init];
  if (self) {
    _selectedColors = [[NSMutableArray alloc] init];
    
    NSArray *storedColorsData = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedColorsUserDefaultsKey];
    if (storedColorsData.count < kMaxSelectedColorCount) {
      NSArray *fillerColors = [NSArray arrayWithObjects:[NSColor redColor], [NSColor greenColor], [NSColor grayColor], [NSColor orangeColor], [NSColor darkGrayColor], nil];
      NSInteger fillerColorIndex = 0;
      for (NSInteger i = 0; i < kMaxSelectedColorCount - storedColorsData.count; ++i) {
        if (fillerColorIndex >= kMaxSelectedColorCount) {
          fillerColorIndex = 0;
        }
        [_selectedColors addObject:[fillerColors objectAtIndex:fillerColorIndex]];
        ++fillerColorIndex;
      }
      
      NSMutableArray *newStoredColorsData = [[NSMutableArray alloc] init];
      for (NSColor *color in _selectedColors) {
        NSData *colorData = [NSArchiver archivedDataWithRootObject:color];
        [newStoredColorsData addObject:colorData];
      }
      [[NSUserDefaults standardUserDefaults] setObject:newStoredColorsData forKey:kSelectedColorsUserDefaultsKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    for (NSData *colorData in storedColorsData) {
      NSColor *color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
      [_selectedColors addObject:color];
    }
    
    _colorFormats = [NSArray arrayWithObjects:[HexFormat new], [Hex2Format new], [RgbFormat new], [RgbaFormat new], [CmykFormat new], nil];
    _colorFormatIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kSelectedColorFormatUserDefaultsKey];
  }
  return self;
}

- (void)setColorFormatIndex:(NSInteger)index
{
  _colorFormatIndex = index;
  
  ColorFormat *selectedColorFormat = [_colorFormats objectAtIndex:_colorFormatIndex];
  NSColor *color = [_selectedColors objectAtIndex:_selectedColors.count - 1];
  [[NSPasteboard generalPasteboard] clearContents];
  [[NSPasteboard generalPasteboard] setString:[selectedColorFormat formatFromColor:color] forType:NSStringPboardType];
  
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:kSelectedColorFormatUserDefaultsKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addSelectedColor:(NSColor *)color
{
  if (color) {
    ColorFormat *selectedColorFormat = [_colorFormats objectAtIndex:_colorFormatIndex];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:[selectedColorFormat formatFromColor:color] forType:NSStringPboardType];
    
    if (_selectedColors.count == kMaxSelectedColorCount) {
      [_selectedColors removeObjectAtIndex:0];
    }
    [_selectedColors addObject:color];
    
    NSMutableArray *storedColorsData = [[NSMutableArray alloc] init];
    for (NSColor *color in _selectedColors) {
      NSData *colorData = [NSArchiver archivedDataWithRootObject:color];
      [storedColorsData addObject:colorData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:storedColorsData forKey:kSelectedColorsUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (NSColor *)moveColorToEndAtIndex:(NSInteger)index
{
  NSColor *color = [_selectedColors objectAtIndex:index];
  NSMutableArray *newSelectedColors = [NSMutableArray new];
  for (int i = 0; i < _selectedColors.count; ++i) {
    if (i != index) {
      [newSelectedColors addObject:[_selectedColors objectAtIndex:i]];
    }
  }
  [newSelectedColors addObject:color];
  _selectedColors = newSelectedColors;
  
  NSMutableArray *storedColorsData = [[NSMutableArray alloc] init];
  for (NSColor *color in _selectedColors) {
    NSData *colorData = [NSArchiver archivedDataWithRootObject:color];
    [storedColorsData addObject:colorData];
  }
  [[NSUserDefaults standardUserDefaults] setObject:storedColorsData forKey:kSelectedColorsUserDefaultsKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return color;
}

@end
