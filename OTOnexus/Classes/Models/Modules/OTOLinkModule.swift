//
//  OTOLinkModule.swift
//  Pods
//
//  Created by Joseph Triska on 12/4/17.
//
//

import Foundation
/**
 OTOLinkModule is a link module that allows a user to visit a link via a link button or image link.
 */
public class OTOLinkModule : OTOModule {
    
    
    var visitedLinkAction:OTOBasicAction?
    /// Url to be visited by user
    public var url = ""
    /// Label to display for link button. Alternately alt or description text if image_url is specified
    public var label = ""
    /// Image to be displayed as link button. Uses value of label for alt or description text if specified
    public var image_url = ""
    
    public func visitedLink() {
        visitedLinkAction?.perform(complete: { (_, _) in
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        let config = responseData.responseDataValue(forKey: "config")
        self.url = config.stringValue(forKey: "url")
        self.label = config.stringValue(forKey: "label")
        self.image_url = config.stringValue(forKey: "image_url")
    }
}
