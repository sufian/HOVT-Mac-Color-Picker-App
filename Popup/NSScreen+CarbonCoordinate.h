//
//  NSScreen+CarbonCoordinate.h
//  Color Picker
//

#import <Cocoa/Cocoa.h>

@interface NSScreen (CarbonCoordinate)

+ (NSScreen*) screenWithPoint: (NSPoint) p;
+ (NSScreen*) screenWithMenuBar;
+ (float) menuScreenHeight;
+ (CGPoint) carbonPointFrom: (NSPoint) cocoaPoint;
+ (NSPoint) cocoaPointFrom: (CGPoint) carbonPoint;

@end
