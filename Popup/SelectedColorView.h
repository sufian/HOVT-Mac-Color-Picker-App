//
//  SelectedColorView.h
//  Popup
//

#import <Cocoa/Cocoa.h>

@interface SelectedColorView : NSView

@property (nonatomic, copy) NSColor *selectedColor;
@property (nonatomic, readonly) NSButton *linkButton;

@property (nonatomic, copy) NSString *topLabelString;
@property (nonatomic, copy) NSString *bottomLabelString;

@property (nonatomic, retain) NSObject *target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) NSInteger index;

@end
