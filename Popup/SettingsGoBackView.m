//
//  SettingsGoBackView.m
//  Popup
//

#import "SettingsGoBackView.h"
#import "NSColor+ColorConstants.h"
#import "VerticalAlignedTextLabel.h"
#import "NSFont+OpenSans.h"

NSInteger kBackButtonToEdgeGap = 5;
NSInteger kViewHeight = 34;
NSInteger kTopLabelWidth = 100;

NSString *kTitle = @"Settings";

@implementation SettingsGoBackView {
  VerticalAlignedTextLabel *_topLabel;
}

@synthesize backButton = _backButton;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    NSImage *leftButtonImage = [[NSBundle mainBundle] imageForResource:@"left format button"];
    _backButton = [[NSButton alloc] initWithFrame:NSMakeRect(kBackButtonToEdgeGap, (kViewHeight - leftButtonImage.size.height) / 2, leftButtonImage.size.width, leftButtonImage.size.height)];
    [_backButton setButtonType:NSMomentaryChangeButton];
    [_backButton setBordered:NO];
    _backButton.imagePosition = NSImageOnly;
    _backButton.image = leftButtonImage;
    [_backButton setFocusRingType:NSFocusRingTypeNone];
    
    [self addSubview:_backButton];
    
    _topLabel = [[VerticalAlignedTextLabel alloc] initWithFrame:NSMakeRect((frame.size.width - kTopLabelWidth) / 2, 3, kTopLabelWidth, frame.size.height - 3)];
    _topLabel.alignment = NSCenterTextAlignment;
    _topLabel.font = [NSFont openSansSemiBoldOfSize:14];
    _topLabel.stringValue = NSLocalizedString(kTitle, nil);
    
    [self addSubview:_topLabel];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{  
  [[NSColor whiteColor] setFill];
  NSRectFill(dirtyRect);
  [super drawRect:dirtyRect];
}

@end
