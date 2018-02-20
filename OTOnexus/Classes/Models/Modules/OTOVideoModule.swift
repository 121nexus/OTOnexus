//
//  OTOVideoModule.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

/**
 OTOVideoModule is a video module that allows a user to view video content stored on the *121nexus platform*. This can be direct video files or videos hosted on video hosting services like YouTube.
 */
public class OTOVideoModule : OTOModule {
    /// Enum for video type returned from platform
    public enum VideoType {
        /// Youtube video type
        case youtube
        /// Direct video type
        case direct
        /// Video type unkown
        case unknown
    }
    
    var videoPlayedAction:OTOBasicAction?
    /// Type of video hosted on platform (i.e Youtube link, direct video file, etc)
    public var videoType = VideoType.unknown
    /// String value of video file url
    public var videoUrl = ""
    /// Function to log video played event to 121nexus platfrom
    public func videoPlayed() {
        videoPlayedAction?.perform(complete: { (_, _) in
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        let config = responseData.responseDataValue(forKey: "config")
        
        if config.stringValue(forKey: "video_type") == "youtube" {
            self.videoType = .youtube
        } else {
            self.videoType = .direct
        }
        
        self.videoUrl = config.stringValue(forKey: "video_url")
        self.videoPlayedAction = self.action(forName: "video_played", responseData: responseData)
    }
}
