//
//  OTOTextModule.swift
//  OTOnexus
//
//  Created by Christopher DeOrio on 11/27/17.
//

import Foundation

public class OTOTextModule : OTOModule {
    
    public var content = ""
    
    override func decode(_ responseData: ResponseData) {
        self.content = responseData.stringValue(forKey: "content")
    }
}