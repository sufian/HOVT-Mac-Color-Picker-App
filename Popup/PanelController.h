#import "BackgroundView.h"
#import "StatusItemView.h"

@class PanelController, MenuBottomView, SettingsGoBackView, ColorFormatSelectionView, SelectedColorView, MASShortcutView;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate>
{
    BOOL _hasActivePanel;
    __unsafe_unretained BackgroundView *_backgroundView;
    __unsafe_unretained id<PanelControllerDelegate> _delegate;
  
  NSView *_activeContainerView;
}

@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;

@property (nonatomic, unsafe_unretained) IBOutlet NSView *menuContainerView;
@property (nonatomic, unsafe_unretained) IBOutlet NSView *preferenceContainerView;

@property (nonatomic, unsafe_unretained) IBOutlet ColorFormatSelectionView *colorFormatSelectionView;
@property (nonatomic, unsafe_unretained) IBOutlet SelectedColorView *selectedColorView0;
@property (nonatomic, unsafe_unretained) IBOutlet SelectedColorView *selectedColorView1;
@property (nonatomic, unsafe_unretained) IBOutlet SelectedColorView *selectedColorView2;
@property (nonatomic, unsafe_unretained) IBOutlet SelectedColorView *selectedColorView3;
@property (nonatomic, unsafe_unretained) IBOutlet SelectedColorView *selectedColorView4;
@property (nonatomic, unsafe_unretained) IBOutlet MenuBottomView *menuBottomView;
@property (nonatomic, unsafe_unretained) IBOutlet SettingsGoBackView *settingsGoBackView;

@property (nonatomic, unsafe_unretained) IBOutlet MASShortcutView *shortcutRecordView;

@property (copy) void (^shotcutHandler)();

@property (nonatomic, readonly) NSButton *launchAtLoginButton;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

@end
