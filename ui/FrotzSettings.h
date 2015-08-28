
#import <UIKit/UIKit.h>
#import "GettingStarted.h"
#import "AboutFrotz.h"
#import "ReleaseNotes.h"
#import "ColorPicker.h"
#import "FontPicker.h"
#import "FrotzDB.h"

@class StoryBrowser;

NS_ASSUME_NONNULL_BEGIN

@protocol FrotzSettingsInfoDelegate <NSObject>
-(void)dismissInfo;
@end

@protocol FrotzSettingsStoryDelegate <NSObject,FrotzFontDelegate>
-(void)resetSettingsToDefault;
-(void)setBackgroundColor:(nullable UIColor*)color makeDefault:(BOOL)makeDefault;
-(void)setTextColor:(nullable UIColor*)color makeDefault:(BOOL)makeDefault;
-(UIColor*)backgroundColor;
-(UIColor*)textColor;
@property (nonatomic, readonly, copy) NSString *rootPath;
@property (nonatomic, getter=isCompletionEnabled) BOOL completionEnabled;
@property (nonatomic) BOOL canEditStoryInfo;
-(void)savePrefs;
-(StoryBrowser*)storyBrowser;
@end

@class FileTransferInfo;

@interface FrotzSettingsController : UITableViewController <UITableViewDelegate, UITableViewDataSource, ColorPickerDelegate>
- (instancetype)init;

@property (nonatomic, readonly) BOOL settingsActive;
@property (nonatomic, strong) id<FrotzSettingsInfoDelegate> infoDelegate;
@property (nonatomic, strong) id<FrotzSettingsStoryDelegate,FrotzFontDelegate> storyDelegate;
@property (nonatomic, readonly, copy, nullable) NSString *rootPath;
- (void)donePressed;
- (void)colorPicker:(ColorPicker*)picker selectedColor:(UIColor*)color;
@property (nonatomic, readonly, copy, nullable) UIFont *fontForColorDemo;
- (void)updateAccessibility;

@end

NS_ASSUME_NONNULL_END
