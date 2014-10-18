//
//  Constants.m
//  Color Picker
//

#import "Constants.h"
#import <Carbon/Carbon.h>

NSString *kSelectedColorsUserDefaultsKey = @"draftbeta.ColorPicker.SelectedColors";

NSString *kMagnifierShortcutUserDefaultsKey = @"draftbeta.ColorPicker.MagnifierShortcut";
NSUInteger kMagnifierShortcutDefaultKeyCode = kVK_ANSI_K;
NSUInteger kMagnifierShortcutDefaultModifierKeyCode = NSCommandKeyMask|NSAlternateKeyMask;

NSString *kSelectedColorFormatUserDefaultsKey = @"draftbeta.ColorPicker.SelectedColorFormat";
NSUInteger kDefaultSelectedColorFormatIndex = 0;

NSString *kHexColorFormatShortDisplayedName = @"HEX";
NSString *kHex2ColorFormatShortDisplayedName = @"HEX2";
NSString *kRgbaColorFormatShortDisplayedName = @"RGBA";
NSString *kCmykColorFormatShortDisplayedName = @"CMYK";

int kMaxSelectedColorCount = 5;

size_t kAreaPixelCount = 15;
int kZoomLevel = 10;

NSInteger kMenuWidth = 240;

NSInteger kTopMenuItemHeight = 24;
NSInteger kTopMenuItemIconDimension = 20;
NSInteger kTopMenuItemEdgeGap = 40;
NSInteger kTopTextFieldToIconGap = 5;
NSInteger kTopTextSize = 15;

NSString *kTopTextFontName = @"Helvetica";
NSString *kTopMenuText = @"Color Picker";

NSInteger kColorSelectionMenuItemHeight = 26;
NSInteger kColorSelectionButtonDimension = 24;
NSInteger kColorSelectionButtonToEdgeGap = 15;
NSInteger kSelectedColorDisplayViewWidth = 100;

NSString *kSelectedColorFormatDisplayFontName = @"Helvetica";
NSInteger kSelectedColorFormatDisplayFontSize = 15;

NSInteger kSelectedColorDisplayMenuItemHeight = 26;
NSInteger kSelectedColorDisplayMenuItemStartIndex = 4;
NSInteger kSelectedColorDisplayMenuItemColorCircleLeftEdgeGap = 20;
NSInteger kSelectedColorDisplayMenuItemColorCircleDimension = 22;
NSInteger kSelectedColorDisplayMenuItemColorValueLabelLeftGap = 10;
NSInteger kSelectedColorDisplayMenuItemColorValueLabelWidth = 170;
NSString *kSelectedColorDisplayMenuItemColorValueLabelFontName = @"Helvetica";
NSInteger kSelectedColorDisplayMenuItemColorValueLabelFontSize = 15;

NSInteger kBottomMenuItemHeight = 26;
NSInteger kPreferenceWindowButtonLeftEdgeGap = 15;
NSInteger kPreferenceWindowButtonDimension = 24;
NSInteger kBottomMenuItemVerticalSeparatorLeftGap = 10;
NSInteger kBottomMenuItemVerticalSeparatorHeight = 24;
NSInteger kBottomMenuItemVerticalSeparatorWidth = 2;

NSString *kQuitAppText = @"Quit";