//
//  FontPicker.h
//  Frotz
//
//  Created by Craig Smith on 9/6/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrotzFontDelegate <NSObject>
-(void) setFont: (nullable NSString*)font withSize:(NSInteger)size;
@property (nonatomic, readonly, copy) NSString *font;
@property (nonatomic, copy) NSString *fixedFont;
@property (nonatomic, readonly) NSInteger fontSize;
@end

@interface FrotzFontInfo : NSObject
-(instancetype)initWithFamily:(NSString*)aFamily fontName:(NSString*)aFont font:(UIFont*)aFont NS_DESIGNATED_INITIALIZER;

@property(nonatomic,copy) NSString *family;
@property(nonatomic,copy) NSString *fontName;
@property(nonatomic,strong) UIFont *font;
@end

@interface FontPicker : UITableViewController 
@property (nonatomic, weak, nullable) id<FrotzFontDelegate> delegate;
@property (nonatomic, assign) BOOL fixedFontsOnly;

- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
