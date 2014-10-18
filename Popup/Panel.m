#import "Panel.h"

@implementation Panel

- (BOOL)canBecomeKeyWindow;
{
    return YES; // Allow Search field to become the first responder
}

- (void)becomeKeyWindow
{
  //NSLog(@"panel becomes key");
  [super becomeKeyWindow];
}

@end
