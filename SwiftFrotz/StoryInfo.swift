//
//  StoryInfo.swift
//  Frotz
//
//  Created by C.W. Betts on 8/27/15.
//
//

import Foundation

func ==(lhs: StoryInfo, rhs: StoryInfo) -> Bool {
    return lhs.path == rhs.path
}

class StoryInfo: NSObject {
    var path: String
    weak var browser: StoryBrowser?
    
    var title: String {
        let storyName = path.storyKey
        let title = browser!.fullTitleForStory(storyName)
        return title
    }
    
    init(path storyPath: String, browser: StoryBrowser) {
        path = storyPath
        self.browser = browser
        super.init()
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? StoryInfo {
            return self == other
        }
        return false
    }
}
