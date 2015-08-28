//
//  StoryInputLine.h
//  Frotz
//
//  Created by Craig Smith on 2/9/10.
//  Copyright 2010 Craig Smith. All rights reserved.
//

#import "StoryMainViewController.h"
#import "CompletionLabel.h"

@interface StoryInputLine: UITextField <FrotzInputDelegate>
-(StoryInputLine*)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) StoryView *storyView;
@property (nonatomic, strong) StatusLine *statusLine;
-(void)resetState;
@property (nonatomic, readonly) BOOL updatePosition;
-(BOOL)handleTouch: (UITouch*)touch withEvent: (UIEvent*)event;
-(NSUInteger)addHistoryItem:(NSString*)historyItem;
-(void)inputHelperString:(NSString*)string;
-(void)hideInputHelper;
@property (nonatomic, readonly, strong) UIView *inputHelperView;
-(void)setClearButtonMode;
-(void)maybeShowEnterKey;
-(void)hideEnterKey;
-(void)setTextKeepCompletion:(NSString*)text;
@end

