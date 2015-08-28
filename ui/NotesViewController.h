//
//  NotesViewController.h
//  Frotz
//
//  Created by Craig Smith on 9/6/10.
//  Copyright 2010 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LockableKeyboard <NSObject>
-(void)showKeyboardLockState;
@end

@interface NotesViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, FileSelected> 

-(instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy) NSString *text;
-(void)setFrame:(CGRect)frame;
-(void)setChainResponder:(UIResponder*)responder;
-(void)activateKeyboard;
-(void)dismissKeyboard;
-(void)toggleKeyboard;
@property (nonatomic, readonly, strong) UIScrollView *containerScrollView;
-(void) keyboardWillShow:(CGRect)kbBounds;
-(void) keyboardWillHide;
@property (nonatomic, getter=isVisible, readonly) BOOL visible;
-(void)show;
-(void)hide;
-(void)loadView;
-(void)autosize;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
-(void)viewWillAppear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animated;
@property (nonatomic, weak, nullable) UIViewController<TextFileBrowser,FileSelected,LockableKeyboard>* delegate;
-(void)workaroundFirstResponderBug;
@end

NS_ASSUME_NONNULL_END
