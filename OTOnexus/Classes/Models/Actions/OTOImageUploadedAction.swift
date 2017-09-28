//
//  OTOImageUploadedAction.swift
//  AWSCore
//
//  Created by Nicholas Schlueter on 9/28/17.
//

import Foundation

class OTOImageUploadedAction : OTOAction<OTOActionResponse> {
    var s3Url = ""
    
    required public init() {
        super.init()
        self.url = "sessions/1/modules/3/image_uploaded"
    }
    
    override func actionArguments() -> [String : Any] {
        return ["s3_url":self.s3Url]
    }
}
