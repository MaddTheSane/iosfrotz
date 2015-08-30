//
//  StoryBrowser.swift
//  Frotz
//
//  Created by C.W. Betts on 8/27/15.
//
//

import Foundation

class StoryBrowser {
    func fullTitleForStory(story: String) -> String {
        return story
    }
	
	/*
init()
var launchPath: String
var navTitleView: UIView { get }
var storyNames: [StoryInfo] { get }
func storyIsInstalled(story: String) -> Bool
func canonicalStoryName(story: String) -> String?
var unsupportedStoryNames: [String] { get }
func addRecentStoryInfo(storyInfo: StoryInfo)
func addRecentStory(storyInfo: String)
func addPath(path: String)
var lowMemory: Bool { get }
func refresh()
func reloadData()
func updateNavButton()
var nowPlayingNavItem: UIBarButtonItem? { get }
var storyMainViewController: StoryMainViewController { get }
var frotzInfoController: FrotzInfo { get }
var settings: FrotzSettingsController { get }
var detailsController: StoryDetailsController { get }
func refreshDetails()
func setStoryDetails(storyInfo: StoryInfo)
func showStoryDetails(storyInfo: StoryInfo)
func showMainStoryController()
func autoRestoreAndShowMainStoryController()
func didPressModalStoryListButton()
func hidePopover()
func addTitle(fullName: String, forStory story: String)
func addAuthors(authors: String, forStory story: String)
func addTUID(tuid: String, forStory story: String)
func addDescript(descript: String, forStory story: String)
var canEditStoryInfo: Bool { get }
func fullTitleForStory(story: String) -> String
func customTitleForStory(story: String, storyKey: AutoreleasingUnsafeMutablePointer<NSString?>) -> String?
func tuidForStory(story: String) -> String
func authorsForStory(story: String) -> String
func descriptForStory(story: String) -> String
func thumbDataForStory(story: String) -> NSData
func addThumbData(imageData: NSData, forStory story: String)
func addSplashData(imageData: NSData, forStory story: String)
func splashDataForStory(story: String) -> NSData
func removeSplashDataForStory(story: String)
func splashPathForStory(story: String) -> String
func cacheSplashPathForBuiltinStory(story: String) -> String
func userSplashPathForStory(story: String) -> String
var builtinSplashes: [String] { get }
func hideStory(story: String, withState hide: Bool)
func unHideAll()
func isHidden(story: String) -> Bool
func getNotesForStory(story: String) -> String?
func saveNotes(notesText: String, forStory story: String)
func saveRecents()
func saveStoryInfoDict()
func saveMetaData()
func mapInfocom83Filename(story: String) -> String
func launchStory(storyPath: String)
func launchStoryInfo(storyInfo: StoryInfo)
func resumeStory()
var resourceGamePath: String { get }
var currentStory: String { get }
func launchBrowserWithURL(url: String)
func launchBrowser()
func indexRowFromStoryInfo(recentStory: StoryInfo) -> UInt
func recentRowFromStoryInfo(storyInfo: StoryInfo) -> UInt
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
func storyInfoForIndexPath(indexPath: NSIndexPath, tableView: UITableView) -> StoryInfo?
func storyForIndexPath(indexPath: NSIndexPath, tableView: UITableView) -> String
func storyInfoChanged()
func updateAccessibility()

var popoverController: UIPopoverController?
var popoverBarButton: UIBarButtonItem?
var searchDisplayController: UISearchDisplayController
*/
}

extension String {
    var storyKey: String {
		var storyKey = ((self as NSString).lastPathComponent.stringByRemovingPercentEncoding! as NSString).stringByDeletingPathExtension
		if storyKey.hasSuffix(".gblorb") || storyKey.hasSuffix(".zblorb") { // remove redundant ext, e.g., otto_scarabeekatana.gblorb.blb
			storyKey = (storyKey as NSString).stringByDeletingPathExtension
		}
		return storyKey
    }
}
