//
//  VerticalAlignedTextLabel.m
//  Color Picker
//

#import "VerticalAlignedTextLabel.h"
#import "RSVerticallyCenteredTextFieldCell.h"

@implementation VerticalAlignedTextLabel

+ (void)initialize
{
  [VerticalAlignedTextLabel setCellClass:[RSVerticallyCenteredTextFieldCell class]];
}

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setEditable:NO];
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setSelectable:NO];
  }
  return self;
}

@end
