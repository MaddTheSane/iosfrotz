//
//  BookmarkListController.h
//  Frotz
//
//  Created by Craig Smith on 8/6/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BookmarkDelegate <NSObject>
-(void)enterURL:(NSString*)url;
-(nullable NSString*)currentURL;
-(nullable NSString*)currentURLTitle;
-(void)hideBookmarks;
-(void)loadBookmarksWithURLs:(NSArray<NSString*>*__nullable*__nullable)urls andTitles:(NSArray<NSString*>*__nullable*__nullable)titles;
-(void)saveBookmarksWithURLs:(NSArray<NSString*>*)urls andTitles:(NSArray<NSString*>*)titles;
-(NSString*)bookmarkPath;
@end

@interface BookmarkListController : UITableViewController
@property (nonatomic, weak) id<BookmarkDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
