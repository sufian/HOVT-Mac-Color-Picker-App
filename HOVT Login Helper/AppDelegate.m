//
//  AppDelegate.m
//  HOVT Login Helper
//

#import "AppDelegate.h"

static NSString *mainAppBundleId = @"draftbeta.HOVT";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSProcessInfo *processInfo = [NSProcessInfo processInfo];
  int processId = [processInfo processIdentifier];
  int milliseconds = arc4random() % 50 * 40;
  NSLog(@"Helper PID: %d, will sleep %d milliseconds", processId, milliseconds);
  usleep(milliseconds * 1000);
  
  // Check if main app is already running; if yes, do nothing and terminate helper app
  BOOL alreadyRunning = NO;
  NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
  for (NSRunningApplication *app in running) {
    if ([[app bundleIdentifier] isEqualToString:mainAppBundleId]) {
      alreadyRunning = YES;
      NSLog(@"HelperPID: %d, %@ status: running:%d.", processId, app.bundleIdentifier, alreadyRunning);
      break;
    }
  }
  
  if (!alreadyRunning) {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *p = [path pathComponents];
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents addObject:@"MacOS"];
    [pathComponents addObject:@"HOVT"];
    NSString *newPath = [NSString pathWithComponents:pathComponents];
    BOOL launched = [[NSWorkspace sharedWorkspace] launchApplication:newPath];
    
    NSLog(@"HelperPID: %d, launched \"%@\": %d", processId, newPath, launched);
  }
  [NSApp terminate:nil];
}

@end
