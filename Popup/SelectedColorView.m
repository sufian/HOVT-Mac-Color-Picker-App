//
//  SelectedColorView.m
//  Popup
//

#import "SelectedColorView.h"
#import "NSColor+ColorConstants.h"
#import "VerticalAlignedTextLabel.h"
#import "NSFont+OpenSans.h"

#import "ApplicationDelegate.h"
#import "SelectedColorsManager.h"
#import "ColorFormat.h"
#import "Hex2Format.h"
#import "MenubarController.h"

NSInteger kColorCircleLeftGap = 15;
NSInteger kColorCircleDimension = 22;
NSInteger kLinkButtonRightGap = 15;

NSInteger kLabelLeftGap = 12;
NSInteger kLabelWidth = 180;
NSInteger kTopLabelHeight = 24;
NSInteger kButtomLabelHeight = 2;
//NSInteger kButtomLabelHeight = 16;

static Hex2Format *_hex2Format;

@implementation SelectedColorView {
  NSTrackingRectTag _trackingRect;
  BOOL _mouseInside;
  NSImage *_linkIcon;
  
  VerticalAlignedTextLabel *_topLabel, *_bottomLabel;
  NSDictionary *_topLabelAttributes, *_buttomLabelAttributes;
}

@synthesize selectedColor = _selectedColor;
@synthesize linkButton = _linkButton;

@synthesize topLabelString = _topLabelString, bottomLabelString = _bottomLabelString;

@synthesize target = _target;
@synthesize action = _action;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _mouseInside = NO;
    
    if (!_hex2Format) {
      _hex2Format = [Hex2Format new];
    }
        
    NSImage *linkIcon = [[NSBundle mainBundle] imageForResource:@"color link"];
    _linkButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.bounds.size.width - kLinkButtonRightGap - linkIcon.size.width, (self.bounds.size.height - linkIcon.size.height) / 2, linkIcon.size.width, linkIcon.size.height)];
    [_linkButton setButtonType:NSMomentaryChangeButton];
    [_linkButton setBordered:NO];
    _linkButton.imagePosition = NSImageOnly;
    _linkButton.image = linkIcon;
    [_linkButton setHidden:YES];
    _linkButton.target = self;
    _linkButton.action = @selector(launchLink);
    
    [self addSubview:_linkButton];
    
    NSPoint buttomLabelOrigin = NSMakePoint(kColorCircleLeftGap + kColorCircleDimension + kLabelLeftGap, (self.bounds.size.height - kTopLabelHeight - kButtomLabelHeight) / 2 + 5);
    NSPoint topLabelOrigin = NSMakePoint(buttomLabelOrigin.x, buttomLabelOrigin.y + kButtomLabelHeight - 4);
    
    NSMutableParagraphStyle *topLabelTextParagraph = [[NSMutableParagraphStyle alloc] init];
    [topLabelTextParagraph setLineSpacing:0];
    _topLabelAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont openSansSemiBoldOfSize:15], NSFontAttributeName, [NSColor darkGrayColor], NSForegroundColorAttributeName, topLabelTextParagraph, NSParagraphStyleAttributeName, nil];
    _topLabel = [[VerticalAlignedTextLabel alloc] initWithFrame:NSMakeRect(topLabelOrigin.x, topLabelOrigin.y, kLabelWidth, kTopLabelHeight)];
    
//    NSMutableParagraphStyle *buttomLabelTextParagraph = [[NSMutableParagraphStyle alloc] init];
//    [buttomLabelTextParagraph setLineSpacing:0];
//    _buttomLabelAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont openSansSemiBoldOfSize:9], NSFontAttributeName, [NSColor lightGrayColor], NSForegroundColorAttributeName, buttomLabelTextParagraph, NSParagraphStyleAttributeName, nil];
//    _bottomLabel = [[VerticalAlignedTextLabel alloc] initWithFrame:NSMakeRect(buttomLabelOrigin.x, buttomLabelOrigin.y, kLabelWidth - 20, kButtomLabelHeight)];
    
    [self addSubview:_topLabel];
//    [self addSubview:_bottomLabel];
    
    self.target = self;
    self.action = @selector(pressed);
  }
  
  return self;
}

- (void)pressed
{
  ApplicationDelegate *delegate = (ApplicationDelegate *)[NSApp delegate];
  SelectedColorsManager *manager = delegate.selectedColorsManager;
  [manager moveColorToEndAtIndex:self.index];
  
  ColorFormat *selectedColorFormat = [manager.colorFormats objectAtIndex:manager.colorFormatIndex];
  [[NSPasteboard generalPasteboard] clearContents];
  [[NSPasteboard generalPasteboard] setString:[selectedColorFormat formatFromColor:self.selectedColor] forType:NSStringPboardType];
  
  [delegate.panelController closePanel];
}
                                          
- (void)setTopLabelString:(NSString *)topLabelString
{
  _topLabelString = topLabelString;
  NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:topLabelString attributes:_topLabelAttributes];
  _topLabel.attributedStringValue = attributeString;
}

- (void)setBottomLabelString:(NSString *)bottomLabelString
{
  _bottomLabelString = bottomLabelString;
  NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:bottomLabelString attributes:_buttomLabelAttributes];
  _bottomLabel.attributedStringValue = attributeString;
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSColor *backgroundColor = _mouseInside ? [NSColor selectedColorViewHighlight] : [NSColor whiteColor];
  [backgroundColor setFill];
  NSRectFill(self.bounds);
  
  [[NSColor selectedColorViewTopSeparator] setStroke];
  [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
  
  NSRect colorCircleRect = NSMakeRect(kColorCircleLeftGap, (self.bounds.size.height - kColorCircleDimension) / 2, kColorCircleDimension, kColorCircleDimension);
  NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:colorCircleRect];
  [self.selectedColor setFill];
  [path fill];
}

- (void)viewDidMoveToWindow
{
  _trackingRect = [self addTrackingRect:self.bounds owner:self userData:NULL assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
  _mouseInside = YES;
  [_linkButton setHidden:NO];
  [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
  _mouseInside = NO;
  [_linkButton setHidden:YES];
  [self setNeedsDisplay:YES];
}

- (void)launchLink
{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://dribbble.com/colors/%@", [_hex2Format formatFromColor:self.selectedColor]]]];
}

- (void)mouseUp:(NSEvent *)theEvent
{
  [self.target performSelector:self.action withObject:nil];
}

@end
