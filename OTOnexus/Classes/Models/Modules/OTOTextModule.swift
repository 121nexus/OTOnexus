//
//  OTOTextModule.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation
/**
 OTOTextModule is a text module that allows a user to display text content stored on teh *Soom platform*.
 */
public class OTOTextModule : OTOModule {
    
    /// A property used to hold the text content
    public var content = ""
    
    override func decode(_ responseData: ResponseData) {
        let config = responseData.responseDataValue(forKey: "config")
        self.content = config.stringValue(forKey: "content")
    }
}
