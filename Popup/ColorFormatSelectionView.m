//
//  ColorFormatSelectionView.m
//  Popup
//

#import "ColorFormatSelectionView.h"
#import "VerticalAlignedTextLabel.h"
#import "NSFont+OpenSans.h"

NSInteger kColorFormatSelectionButtonToEdgeGap = 5;
NSInteger kColorFormatSelectionMenuItemHeight = 34;
NSInteger kColorFormatLabelWidth = 100;

@implementation ColorFormatSelectionView {
  VerticalAlignedTextLabel *_formatLabel;
}

@synthesize leftFormatButton = _leftFormatButton;
@synthesize rightFormatButton = _rightFormatButton;
@synthesize formatLabel = _formatLabel;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    NSImage *leftButtonImage = [[NSBundle mainBundle] imageForResource:@"left format button"];
    NSButton *leftColorFormatButton = [[NSButton alloc] initWithFrame:NSMakeRect(kColorFormatSelectionButtonToEdgeGap, (kColorFormatSelectionMenuItemHeight - leftButtonImage.size.height) / 2, leftButtonImage.size.width, leftButtonImage.size.height)];
    [leftColorFormatButton setButtonType:NSMomentaryChangeButton];
    [leftColorFormatButton setBordered:NO];
    leftColorFormatButton.imagePosition = NSImageOnly;
    leftColorFormatButton.image = leftButtonImage;
    [leftColorFormatButton setFocusRingType:NSFocusRingTypeNone];
    _leftFormatButton = leftColorFormatButton;
    
    [self addSubview:leftColorFormatButton];
    
    NSImage *rightButtonImage = [[NSBundle mainBundle] imageForResource:@"right format button"];
    NSButton *rightColorFormatButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - kColorFormatSelectionButtonToEdgeGap - rightButtonImage.size.width, (kColorFormatSelectionMenuItemHeight - rightButtonImage.size.height) / 2, rightButtonImage.size.width, rightButtonImage.size.height)];
    [rightColorFormatButton setButtonType:NSMomentaryChangeButton];
    [rightColorFormatButton setBordered:NO];
    rightColorFormatButton.imagePosition = NSImageOnly;
    rightColorFormatButton.image = rightButtonImage;
    [rightColorFormatButton setFocusRingType:NSFocusRingTypeNone];
    _rightFormatButton = rightColorFormatButton;
    
    [self addSubview:rightColorFormatButton];
    
    _formatLabel = [[VerticalAlignedTextLabel alloc] initWithFrame:NSMakeRect((frame.size.width - kColorFormatLabelWidth) / 2, 3, kColorFormatLabelWidth, frame.size.height - 3)];
    _formatLabel.alignment = NSCenterTextAlignment;
    
    [self addSubview:_formatLabel];
    
    _formatLabel.font = [NSFont openSansSemiBoldOfSize:14];
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
