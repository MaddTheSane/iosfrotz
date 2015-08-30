//
//  StoryDetailsController.swift
//  Frotz
//
//  Created by C.W. Betts on 8/29/15.
//
//

import Cocoa

class StoryDetailsController: NSWindowController {
	@IBOutlet weak var titleField: NSTextField?
	@IBOutlet weak var authorField: NSTextField?
	@IBOutlet weak var tuidField: NSTextField?
	@IBOutlet weak var artworkView: NSImageView?
/*
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
*/
	
	@IBAction func playButtonPressed(sender: AnyObject?) {
		
	}
	
	@IBAction func IFDBButtonPressed(sender: AnyObject?) {
		
	}
	
	@IBAction func showRestartMenu(sender: AnyObject?) {
		
	}

	
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
