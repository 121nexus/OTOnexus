//
//  OTOVideoModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/3/17.
//

import Foundation

public class OTOVideoModule : OTOModule {
    public enum VideoType {
        case youtube, direct, unknown
    }
    var videoPlayedAction:OTOBasicAction?
    public var videoType = VideoType.unknown
    public var videoUrl = ""
    
    public func videoPlayed() {
        videoPlayedAction?.perform(complete: { (_, _) in
            
        })
    }
    
    override func populateActions(withUrlBase urlBase: String) {
        super.populateActions(withUrlBase: urlBase)
        let videoPlayedEndpoint = self.actionEndpoint(withUrlBase: urlBase, actionName: "video_played")
        self.videoPlayedAction = OTOBasicAction(url:videoPlayedEndpoint)
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
    }
}
