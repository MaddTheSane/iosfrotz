//
//  GlkView.h
//  Frotz
//
//  Created by Craig Smith on 2/9/10.
//  Copyright 2010 Craig Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryMainViewController.h"
#import "FrotzView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlkView : FrotzView {
    NSTimer *m_tapTimer;
    BOOL m_skipNextTap;
    BOOL m_tapInputEnabled;
}
- (BOOL)handleTouch: (UITouch*)touch withEvent: (UIEvent*)event;
- (void)skipNextTap;

@property (nonatomic, assign) BOOL tapInputEnabled;
@end

NS_ASSUME_NONNULL_END

