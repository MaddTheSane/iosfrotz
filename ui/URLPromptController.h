//
//  URLPromptController.h
//  Frotz
//
//  Created by Craig Smith on 8/6/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol URLPromptDelegate <NSObject>
-(void)promptURL;
-(void)enterURL:(NSString*)url;
-(void)dismissURLPrompt;
-(void)showBookmarks;
@end

@interface URLPromptController : UIViewController <UISearchBarDelegate>

-(void)setText:(NSString*)text;
-(void)setPlaceholder:(NSString*)text;
@property (nonatomic, weak) id<URLPromptDelegate> delegate;
@end

#define kSearchBarHeight		40.0

