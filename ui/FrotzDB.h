
#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface FrotzDBController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, weak, nullable) id delegate;

- (nonnull instancetype)init;

- (void)donePressed;
@end

