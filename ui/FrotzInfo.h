//
//  FrotzInfo.h
//  Frotz
//
//  Created by Craig Smith on 8/3/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrotzSettings.h"
#import "ColorPicker.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KeyboardOwner <NSObject>
-(nullable id)dismissKeyboard;
@end

@interface FrotzInfo : UIViewController <FrotzSettingsInfoDelegate>

-(instancetype)initWithSettingsController:(FrotzSettingsController*)settings navController:(UINavigationController*)navController navItem: (UINavigationItem*) navItem NS_DESIGNATED_INITIALIZER;
-(void)dismissInfo;
-(void)frotzInfo;
@property (nonatomic, strong) id<KeyboardOwner> keyboardOwner;
@property (nonatomic, readonly, strong) UINavigationController *navController;
@property (nonatomic, readonly, strong) UINavigationItem *navItem;
-(void)updateAccessibility;
-(void)updateTitle;
@end

NS_ASSUME_NONNULL_END
