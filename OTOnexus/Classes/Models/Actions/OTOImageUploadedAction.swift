//
//  OTOImageUploadedAction.swift
//  AWSCore
//
//  Created by Nicholas Schlueter on 9/28/17.
//

import Foundation

class OTOImageUploadedAction : OTOAction<OTOActionResponse> {
    var s3Url = ""
    
    override func bodyParams() -> [String:Any] {
        return ["s3_url":self.s3Url]
    }
}
