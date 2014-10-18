//
//  SelectedColorsManager.h
//  Color Picker
//

#import <Foundation/Foundation.h>

@interface SelectedColorsManager : NSObject

- (void)addSelectedColor:(NSColor *)color;
- (NSColor *)moveColorToEndAtIndex:(NSInteger)index;

@property (nonatomic) NSInteger colorFormatIndex;
@property (nonatomic, readonly) NSArray *selectedColors;

@property (nonatomic, readonly) NSArray *colorFormats;

@end
