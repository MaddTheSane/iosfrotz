/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
// Pilfered from NES.app.
// Many thanks to its authors.

#import <UIKit/UIKit.h>

@class FileInfo;
@class FileBrowser;

typedef NS_ENUM(int, FileBrowserState)  { kFBHidden, kFBShown, kFBDoShowRestore, kFBDoShowSave, kFBDoShowScript, kFBDoShowViewScripts, kFBDoShowRecord, kFBDoShowPlayback  };

NS_ASSUME_NONNULL_BEGIN

@protocol TextFileBrowser <NSObject>
@property (nonatomic, readonly, copy) NSString *textFileBrowserPath;
@end


@protocol FileSelected <NSObject>
@optional
-(void)fileBrowser:(FileBrowser*)browser fileSelected: (nullable NSString*)filePath;
-(void)fileBrowser:(FileBrowser*)browser deleteFile: (NSString*)filePath;
@end

@interface FileBrowser : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithDialogType:(FileBrowserState)dialogType NS_DESIGNATED_INITIALIZER;
@property (nonatomic, copy) NSString *path;
- (void)reloadData;
@property (nonatomic, weak, nullable) id<FileSelected> delegate;
@property (nonatomic, readonly, copy, nullable) NSString *selectedFile;
- (void)commit:(id)sender;
- (void)doneWithTextFile:(id)sender;
- (void)addExtension: (NSString *)extension;
@property (nonatomic, readonly) int textFileCount;
@end

NS_ASSUME_NONNULL_END
