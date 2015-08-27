//
//  ReleaseNotes.h
//  Frotz
//
//  Created by Craig Smith on 8/29/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrotzCommonWebView.h"


@interface ReleaseNotes : FrotzCommonWebViewController {
    NSObject *m_controller;
    NSURLRequest *m_request;
    NSURLConnection *m_connection;
    NSMutableData *m_data;
    NSString *m_relNotesPath;
    UIButton *m_rateButton;
}
- (instancetype)init;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (void)updateReleaseNotes:(BOOL)force;
- (void)updateReleaseNotesAuto;
- (void)showReleaseNotes;
- (void)loadView;
- (void)rateFrotz;
@end
