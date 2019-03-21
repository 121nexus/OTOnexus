//
//  OTODownloadResponse.swift
//  OTOnexus
//
//  Created by Joseph Triska on 3/20/19.
//

import Foundation

public class OTODownloadResponse: OTOActionResponse {
    public var documentUrl = ""
    
    override func decode(_ responseData: ResponseData) {
        self.documentUrl = responseData.stringValue(forKey: "document_url")
    }

}
