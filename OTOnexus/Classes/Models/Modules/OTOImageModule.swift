//
//  OTOImageModule.swift
//  Pods
//
//  Created by Joseph Triska on 12/4/17.
//
//

import Foundation
/**
 OTOImageModule is an image module that allows a user to display image content stored on the *121nexus platform* or linked from elsewhere.
 */
public class OTOImageModule : OTOModule {
    
    /// A property used to hold the image's url
    public var url = ""
    /// A property used to hold the image's description, or alt text
    public var description = ""
    
    override func decode(_ responseData: ResponseData) {
        let config = responseData.responseDataValue(forKey: "config")
        self.url = config.stringValue(forKey: "description")
        self.description = config.stringValue(forKey: "description")
    }
}
