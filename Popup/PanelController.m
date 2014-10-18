#import "PanelController.h"
#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MenubarController.h"
#import "MenuBottomView.h"
#import "SettingsGoBackView.h"

#import "ApplicationDelegate.h"
#import "ColorFormatSelectionView.h"
#import "SelectedColorsManager.h"
#import "ColorFormat.h"
#import "SelectedColorView.h"

#import "MASShortcut.h"
#import "MASShortcut+UserDefaults.h"
#import "MASShortcut+Monitoring.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"

#import "Constants.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1

#define SEARCH_INSET 17

#define MENU_WINDOW_HEIGHT 364
#define PREFERENCE_WINDOW_HEIGHT 230
#define PANEL_WIDTH 260
#define MENU_ANIMATION_DURATION .1

#pragma mark -

@implementation PanelController

@synthesize menuContainerView = _menuContainerView, preferenceContainerView = _preferenceContainerView, menuBottomView = _menuBottomView, settingsGoBackView = _settingsGoBackView;

@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;

#pragma mark -

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
  self = [super initWithWindowNibName:@"Panel"];
  if (self != nil)
  {
    _delegate = delegate;
  }
  return self;
}

- (void)preferenceButtonPressed
{
  _activeContainerView = self.preferenceContainerView;
  
  CGRect frame = self.window.frame;
  frame.origin.y += MENU_WINDOW_HEIGHT - PREFERENCE_WINDOW_HEIGHT;
  frame.size.height = PREFERENCE_WINDOW_HEIGHT;
  
  [self.preferenceContainerView setHidden:NO];
  [[NSAnimationContext currentContext] setDuration:.1];
  [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
    [self.menuContainerView.animator setAlphaValue:0];
  } completionHandler:^{
    [self.menuContainerView setHidden:YES];
    [[self.window animator] setFrame:frame display:YES];
    [self.preferenceContainerView.animator setAlphaValue:1];
  }];
}

- (void)backButtonPressed
{
  _activeContainerView = self.menuContainerView;
  
  CGRect frame = self.window.frame;
  frame.origin.y -= MENU_WINDOW_HEIGHT - PREFERENCE_WINDOW_HEIGHT;
  frame.size.height = MENU_WINDOW_HEIGHT;
  
  [self.menuContainerView setHidden:NO];
  [[NSAnimationContext currentContext] setDuration:.15];
  [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
    [self.preferenceContainerView.animator setAlphaValue:0];
  } completionHandler:^{
    [self.preferenceContainerView setHidden:YES];
    [[self.window animator] setFrame:frame display:YES];
    [self.menuContainerView.animator setAlphaValue:1];
  }];
}

- (void)leftColorButtonPressed
{
  ApplicationDelegate *delegate = (ApplicationDelegate *)[NSApp delegate];
  SelectedColorsManager *manager = delegate.selectedColorsManager;
  NSInteger index = manager.colorFormatIndex;
  NSArray *formats = manager.colorFormats;
  
  index -= 1;
  if (index < 0) {
    index = formats.count - 1;
  }
  manager.colorFormatIndex = index;
  
  [self updateColorSelections];
}

- (void)rightColorButtonPressed
{
  ApplicationDelegate *delegate = (ApplicationDelegate *)[NSApp delegate];
  SelectedColorsManager *manager = delegate.selectedColorsManager;
  NSInteger index = manager.colorFormatIndex;
  NSArray *formats = manager.colorFormats;
  
  index += 1;
  if (index >= formats.count) {
    index = 0;
  }
  manager.colorFormatIndex = index;
  
  [self updateColorSelections];
}

#pragma mark -

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  // Make a fully skinned panel
  NSPanel *panel = (id)[self window];
  [panel setAcceptsMouseMovedEvents:YES];
  [panel setLevel:NSPopUpMenuWindowLevel];
  [panel setOpaque:NO];
  [panel setBackgroundColor:[NSColor clearColor]];
  
  // Resize panel
  NSRect panelRect = [[self window] frame];
  panelRect.size.height = MENU_WINDOW_HEIGHT;
  [[self window] setFrame:panelRect display:NO];
  
  _activeContainerView = self.menuContainerView;
  
  [self.window.contentView addSubview:self.preferenceContainerView];
  CGPoint preferenceOrigin = self.preferenceContainerView.frame.origin;
  preferenceOrigin.y += (MENU_WINDOW_HEIGHT - PREFERENCE_WINDOW_HEIGHT);
  [self.preferenceContainerView setFrameOrigin:preferenceOrigin];
  [self.preferenceContainerView setAlphaValue:0];
  [self.preferenceContainerView setHidden:YES];
  
  NSArray *selectedColorMenuItems = [NSArray arrayWithObjects:self.selectedColorView4, self.selectedColorView3, self.selectedColorView2, self.selectedColorView1, self.selectedColorView0, nil];
  for (NSInteger i = 0; i < selectedColorMenuItems.count; ++i) {
    SelectedColorView *view = [selectedColorMenuItems objectAtIndex:i];
    view.index = i;
  }
  
  self.menuBottomView.preferenceButton.target = self;
  self.menuBottomView.preferenceButton.action = @selector(preferenceButtonPressed);
  
  self.settingsGoBackView.backButton.target = self;
  self.settingsGoBackView.backButton.action = @selector(backButtonPressed);
  
  self.colorFormatSelectionView.leftFormatButton.target = self.colorFormatSelectionView.rightFormatButton.target = self;
  self.colorFormatSelectionView.leftFormatButton.action = @selector(leftColorButtonPressed);
  self.colorFormatSelectionView.rightFormatButton.action = @selector(rightColorButtonPressed);
  
  self.shortcutRecordView.associatedUserDefaultsKey = kMagnifierShortcutUserDefaultsKey;
  self.shortcutRecordView.shortcutValueChange = ^(MASShortcutView *shortcutView, MASShortcut *oldValue) {
    [MASShortcut removeGlobalHotkeyMonitor:oldValue.description];
    [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcutView.shortcutValue handler:self.shotcutHandler];
    
    //NSLog(@"changed key");
  };
  
}

#pragma mark - Public accessors

- (BOOL)hasActivePanel
{
  return _hasActivePanel;
}

- (void)setHasActivePanel:(BOOL)flag
{
  if (_hasActivePanel != flag)
  {
    _hasActivePanel = flag;
    
    if (_hasActivePanel)
    {
      [self openPanel];
    }
    else
    {
      [self closePanel];
    }
  }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
  self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
  if ([[self window] isVisible])
  {
    self.hasActivePanel = NO;
  }
}

- (void)windowDidResize:(NSNotification *)notification
{
  NSWindow *panel = [self window];
  NSRect statusRect = [self statusRectForWindow:panel];
  NSRect panelRect = [panel frame];
  
  CGFloat statusX = roundf(NSMidX(statusRect));
  CGFloat panelX = statusX - NSMinX(panelRect);
  
  self.backgroundView.arrowX = panelX;
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
  self.hasActivePanel = NO;
}

#pragma mark - Public methods

- (StatusItemView *)statusItemView
{
  StatusItemView *statusItemView = nil;
  if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
  {
    statusItemView = [self.delegate statusItemViewForPanelController:self];
  }
  return statusItemView;
}

- (NSRect)screenRect
{
  StatusItemView *statusItemView = [self statusItemView];
  NSScreen *screen = [[statusItemView window] screen];
  return screen.frame;
}

- (NSRect)statusRectForWindow:(NSWindow *)window
{
  NSRect screenRect = [self screenRect];
  NSRect statusRect = NSZeroRect;
  
  StatusItemView *statusItemView = [self statusItemView];
  
  if (statusItemView)
  {
    statusRect = statusItemView.globalRect;
    statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
  }
  else
  {
    statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
    statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
    statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
  }
  return statusRect;
}

- (void)updateColorSelections
{
  ApplicationDelegate *delegate = (ApplicationDelegate *)[NSApp delegate];
  ColorFormat *colorFormat = (ColorFormat *)[delegate.selectedColorsManager.colorFormats objectAtIndex:delegate.selectedColorsManager.colorFormatIndex];
  self.colorFormatSelectionView.formatLabel.stringValue = colorFormat.shortDescription;
  NSArray *selectedColorMenuItems = [NSArray arrayWithObjects:self.selectedColorView4, self.selectedColorView3, self.selectedColorView2, self.selectedColorView1, self.selectedColorView0, nil];
  for (NSInteger i = 0; i < selectedColorMenuItems.count; ++i) {
    SelectedColorView *view = [selectedColorMenuItems objectAtIndex:i];
    NSColor *color = [delegate.selectedColorsManager.selectedColors objectAtIndex:i];
    NSString *formattedValue = [colorFormat formatFromColor:color];
    view.topLabelString = formattedValue;
    view.bottomLabelString = [NSString stringWithFormat:@"%@(%@)", colorFormat.shortDescription, formattedValue];
    view.selectedColor = color;
  }
}

- (void)openPanel
{
  NSWindow *panel = [self window];
  
  [self updateColorSelections];
  
  //NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
  NSRect screenRect = [self screenRect];
  NSRect statusRect = [self statusRectForWindow:panel];
  
  NSRect panelRect = [panel frame];
  panelRect.size.width = PANEL_WIDTH;
  panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
  panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect) - 1;
  
  if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
    panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
  
  [NSApp activateIgnoringOtherApps:NO];
  [panel setAlphaValue:0];
  [panel setFrame:statusRect display:YES];
  [panel makeKeyAndOrderFront:nil];
  
  NSTimeInterval openDuration = OPEN_DURATION;
  
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:openDuration];
  [panel setFrame:panelRect display:YES];
  [[panel animator] setAlphaValue:1];
  [NSAnimationContext endGrouping];
}

- (void)closePanel
{
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
  [[[self window] animator] setAlphaValue:0];
  if (self.hasActivePanel) {
    self.hasActivePanel = NO;
  }
  [NSAnimationContext endGrouping];
  
  dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
    [self.window orderOut:nil];
  });
}

@end
