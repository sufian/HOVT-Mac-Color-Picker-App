//
//  ColorFormat.h
//  Color Picker
//

#import <Foundation/Foundation.h>

@interface ColorFormat : NSObject

- (NSString *)formatFromColor:(NSColor *)color;

- (NSString *)formatFromColor:(NSColor *)color withFormatString:(NSString *)formatString;

@property (readonly) NSString *shortDescription;

@end
