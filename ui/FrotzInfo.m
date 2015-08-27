//
//  FrotzInfo.m
//  Frotz
//
//  Created by Craig Smith on 8/3/08.
//  Copyright 2008 Craig Smith. All rights reserved.
//

#include "iosfrotz.h"
#import "FrotzInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "TextViewExt.h"

@interface /*StoryBrowser*/ UITableViewController (Private)
-(void)hidePopover;
@end

@implementation FrotzInfo

-(instancetype)initWithSettingsController:(FrotzSettingsController*)settings navController:(UINavigationController*)navController navItem: (UINavigationItem*) navItem {
	if ((self = [super initWithNibName:nil bundle:nil])) {
	    // Initialization code
        
	    m_navigationController = navController;
	    m_navItem = navItem;
	    m_settings = settings;
	    [m_settings setInfoDelegate: self];
	}
	return self;
}

-(void)loadView {
    [super loadView];
    
    CGRect frame = CGRectMake(0,0, 106, 44);
    
    m_titleTextView = [[UILabel alloc] initWithFrame: CGRectMake(20,0,54,44)];
    [m_titleTextView setText: @"Frotz"];
    
    m_titleTextView.backgroundColor = [UIColor clearColor];
    m_titleTextView.font = [UIFont boldSystemFontOfSize: 20];
    
    UIView *view = [self view];
    [view setAutoresizingMask: UIViewAutoresizingNone];
    [view setFrame: frame];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview: m_titleTextView];
    m_infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    [m_infoButton setFrame: CGRectMake(74, 0, 32, 44)];
    [self updateAccessibility];
    [view addSubview: m_infoButton];
    [m_infoButton addTarget:self action:@selector(frotzInfo) forControlEvents: UIControlEventTouchUpInside];
    
    m_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(frotzInfo)];
    [self updateTitle];

}

-(void)updateTitle {
#ifdef NSFoundationVersionNumber_iOS_6_1
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        UINavigationController *nc = nil;//self.navigationController;
        if (!nc)
            nc = m_navigationController;
        UIColor *color = [nc.navigationBar tintColor];
        [m_titleTextView setTextColor: color];  //[UIColor redColor]];
        [m_infoButton setTintColor: color];
    } else
#endif
        [m_titleTextView setTextColor: [UIColor whiteColor]];

}

-(void)updateAccessibility {
    if ([m_infoButton respondsToSelector: @selector(setAccessibilityLabel:)])
        [m_infoButton setAccessibilityLabel: @"Settings"];
}

-(UINavigationController*)navController {
    return m_navigationController;
}

-(UINavigationItem*)navItem {
    return m_navItem;
}


-(void)setupFade {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    BOOL cache = YES;
#ifdef NSFoundationVersionNumber_iOS_6_1
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        cache = NO;
#endif

    [UIView setAnimationTransition:
     ([m_settings.view superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
                           forView: m_navigationController.view
     //[[[[[m_navigationController topViewController] view] superview] superview] superview]
                             cache:cache];

    [UIView commitAnimations];
}

-(void)dismissInfoModal {
    UIViewController *svc = nil;
    if (gUseSplitVC && (svc = m_navigationController /*.splitViewController*/)) {
        [svc dismissModalViewControllerAnimated:YES];
    }
}

-(void)dismissInfo {
    if ([m_settings settingsActive] || (!gUseSplitVC && [m_settings.view superview])) {
        UIViewController *svc = nil;
        if (gUseSplitVC && (svc = m_navigationController /*.splitViewController*/)) {
            UINavigationController *nc = nil;
            if ((nc = (UINavigationController*)svc.modalViewController)) {
                if ([nc topViewController] != m_settings)
                    [nc popToViewController: m_settings animated:YES];
                [self performSelector:@selector(dismissInfoModal) withObject: nil afterDelay: 0.2];
            }
        } else {
            [self setupFade];
            if (m_navigationController.topViewController != m_settings)
                [m_navigationController popToViewController: m_settings animated:NO];
            [m_navigationController popViewControllerAnimated: NO];
            
            if (m_prevResponder && [m_prevResponder respondsToSelector:@selector(becomeFirstResponder)])
                [m_prevResponder performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
            [UIView commitAnimations];
        }
    }
}

-(void)setKeyboardOwner:(id<KeyboardOwner>)kbdOwner {
    m_kbdOwner = kbdOwner;
}

-(id<KeyboardOwner>)keyboardOwner {
    return m_kbdOwner;
}

-(void)frotzInfo {
    if (![m_settings settingsActive]) {
        if (m_kbdOwner)
            m_prevResponder = [m_kbdOwner dismissKeyboard];
        [m_settings setInfoDelegate: self];
        
        (void)[m_settings view]; // Preload view so animation is smoother
        
        if (gUseSplitVC ) { //&& m_navigationController.splitViewController) {
            UINavigationController *settingsNavController = [m_settings navigationController];
            if (!settingsNavController) {
                settingsNavController = [[UINavigationController alloc] initWithRootViewController: m_settings];
                [settingsNavController.navigationBar setBarStyle: UIBarStyleBlackOpaque];
            }
            if ([[m_navigationController topViewController] respondsToSelector:@selector(hidePopover)])
                [[m_navigationController topViewController] performSelector:@selector(hidePopover)];
            [settingsNavController setModalPresentationStyle: UIModalPresentationFormSheet];
            [m_navigationController /*.splitViewController*/ presentModalViewController: settingsNavController animated:YES];
        }
        else {
            [self setupFade];
            [m_navigationController pushViewController:m_settings animated:NO];
            [UIView commitAnimations];
        }
    }
}
@end

