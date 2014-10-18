#import "MenubarController.h"
#import "PanelController.h"

@class SelectedColorsManager;

@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

@property (nonatomic, readonly) SelectedColorsManager *selectedColorsManager;

- (IBAction)togglePanel:(id)sender;

@property (nonatomic, unsafe_unretained) IBOutlet NSWindow *magnifierWindow;

@end
