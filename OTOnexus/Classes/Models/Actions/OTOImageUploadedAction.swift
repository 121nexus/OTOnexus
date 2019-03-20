//
//  OTOImageUploadedAction.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class OTOImageUploadedAction : OTOAction<OTOActionResponse> {
    var s3Url = ""
    
    override func bodyParams() -> [String : Any] {
        return ["s3_url":self.s3Url]
    }
}
