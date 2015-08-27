
#import <UIKit/UIKit.h>

@class ColorPicker;

NS_ASSUME_NONNULL_BEGIN

@protocol ColorPickerDelegate <NSObject>
-(void)colorPicker:(ColorPicker*)picker selectedColor:(UIColor*)color;
@property (nonatomic, readonly, nullable, copy) UIFont *fontForColorDemo;
@end

NS_ASSUME_NONNULL_END
