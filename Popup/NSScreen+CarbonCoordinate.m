//
//  NSScreen+CarbonCoordinate.m
//  Color Picker
//

#import "NSScreen+CarbonCoordinate.h"

@implementation NSScreen (CarbonCoordinate)

+ (NSScreen*) screenWithPoint: (NSPoint) p
{
    for (NSScreen *candidate in [NSScreen screens])
        if (NSPointInRect(p, [candidate frame]))
            return candidate;
    return nil;
}

+ (NSScreen*) screenWithMenuBar
{
    return [self screenWithPoint:NSZeroPoint];
}

+ (float) menuScreenHeight
{
    return NSMaxY([[self screenWithMenuBar] frame]);
}

+ (CGPoint) carbonPointFrom: (NSPoint) cocoaPoint
{
    return CGPointMake(cocoaPoint.x, [self menuScreenHeight] - cocoaPoint.y);
}

+ (NSPoint) cocoaPointFrom: (CGPoint) carbonPoint
{
    return NSMakePoint(carbonPoint.x, [self menuScreenHeight] - carbonPoint.y);
}

@end
