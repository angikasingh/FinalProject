//
//  TikTokMode;.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import Foundation

class TikTokUserModel {
    
    var id : String = ""
    var name : String = ""
    var thumbnail: String = ""
    var followerCount: String = "0"
    var followingCount: String = "0"
    var mediaCount: String = "0"
    
    init(_ id : String, _ name: String, _ thumbnail: String, _ followerCount: String, _ followingCount: String, _ mediaCount: String) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.mediaCount = mediaCount
    }
}
