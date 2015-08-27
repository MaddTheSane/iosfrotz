//
//  GettingStartedView.h
//  Frotz
//
//  Created by Craig Smith on 8/29/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrotzCommonWebView.h"


NS_ASSUME_NONNULL_BEGIN

@interface GettingStarted : FrotzCommonWebViewController
- (instancetype)init;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
