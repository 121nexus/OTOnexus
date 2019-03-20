//
//  OTODownloadResponse.swift
//  OTOnexus
//
//  Created by Joseph Triska on 3/20/19.
//

import Foundation

public class OTODownloadResponse: OTOActionResponse {
    public var document_url = ""
    
    override func decode(_ responseData: ResponseData) {
        self.document_url = responseData.stringValue(forKey: "document_url")
    }

}
