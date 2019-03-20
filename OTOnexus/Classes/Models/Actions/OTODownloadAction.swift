//
//  OTODownloadAction.swift
//  OTOnexus
//
//  Created by Joseph Triska on 3/20/19.
//

import Foundation

class OTODownloadAction : OTOAction<OTODownloadResponse> {
    override func process(responseObject: ResponseObject) -> OTODownloadResponse? {
        guard let _ = responseObject.data?.responseData(forKey: "document_url") else { return nil }
        return OTODownloadResponse.decode(responseObject.dataValue())
    }
}

