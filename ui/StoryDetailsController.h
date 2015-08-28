//
//  StoryDetailsController.h
//
//  Created by Craig Smith on 9/11/10.
//  Copyright 2010 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "StoryBrowser.h"

@class StoryDetailsController;

@interface FrotzImageView : UIImageView  <UIAlertViewDelegate>

-(void)displayMenu;
@property (nonatomic, getter=isMagnified, readonly) BOOL magnified;
-(void)magnifyImage:(BOOL)toggle;
-(void)doPaste;
@property (nonatomic,weak) StoryDetailsController *detailsController;
@end

@interface StoryDetailsController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIWebViewDelegate>
@property(nonatomic,strong) IBOutlet UITextField *titleField;
@property(nonatomic,strong) IBOutlet UITextField *authorField;
@property(nonatomic,strong) IBOutlet UITextField *tuidField;
@property(nonatomic,strong) IBOutlet FrotzImageView *artworkView;
@property(nonatomic,strong) IBOutlet UIView *textFieldsView;
@property(nonatomic,strong) IBOutlet UIView *buttonsView;
@property(nonatomic,strong) IBOutlet UIView* flipper;
@property(nonatomic,strong) IBOutlet UIWebView* descriptionWebView;
@property(nonatomic,strong) IBOutlet UIButton* infoButton;
@property(nonatomic,strong) IBOutlet UIButton *ifdbButton;
@property(nonatomic,strong) IBOutlet UIButton *playButton;
@property(nonatomic,strong) IBOutlet UILabel *artworkLabel;
@property(nonatomic,strong) IBOutlet UIView *portraitCover;
@property(nonatomic,strong) IBOutlet UILabel *portraitCoverLabel;
@property(nonatomic,strong) IBOutlet UIView* contentView;
@property(nonatomic,strong) IBOutlet UIButton *restartButton;

@property(nonatomic,strong) UINavigationController* detailsNavigationController;

@property(nonatomic,strong) UIImage* artwork;
@property(nonatomic,strong) StoryInfo* storyInfo;
@property(nonatomic,weak) StoryBrowser* storyBrowser;
@property(nonatomic,assign) BOOL willResume;

@property(nonatomic,strong) NSString* storyTitle;
@property(nonatomic,strong) NSString* author;
@property(nonatomic,strong) NSString* descriptionHTML;
@property(nonatomic,strong,setter=setTUID:) NSString* tuid;

-(IBAction) toggleArtDescript;
-(void)repositionArtwork:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)clear;
-(void)refresh;
-(void)updateSelectionInstructions:(BOOL)hasPopover;
@property (nonatomic, readonly) BOOL keyboardIsActive;
-(void)dimArtwork:(BOOL)dim;
-(IBAction)playButtonPressed;
-(IBAction)IFDBButtonPressed;
-(IBAction)dismissKeyboard;
-(IBAction)showRestartMenu;



@end
