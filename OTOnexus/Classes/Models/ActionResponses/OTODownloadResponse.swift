//
//  OTODownloadResponse.swift
//  OTOnexus
//
//  Created by Joseph Triska on 3/20/19.
//

import Foundation

public class OTODownloadResponse: OTOActionResponse {
    public var documentUrlResponse = ""
    
    override func decode(_ responseData: ResponseData) {
        self.documentUrlResponse = responseData.stringValue(forKey: "document_url")
    }

}
