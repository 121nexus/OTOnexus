//
//  OTODocumentDownloadModule.swift
//  OTOnexus
//
//  Created by Joseph Triska on 3/20/19.
//

import Foundation

public class OTODocumentDownloadModule : OTOModule {
    private var downloadAction:OTODownloadAction?
    public var documentUrl = ""
    
    
    public func download(complete:@escaping (OTODownloadResponse?, OTOError?) -> Void) {
        downloadAction?.perform(complete: { (response, error) in
            if let response = response {
                complete(response, nil)
            } else {
                complete(nil, error)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.documentUrl = responseData.responseDataValue(forKey: "config").stringValue(forKey: "document_url")
    
        self.downloadAction = self.action(forName: "download_document", responseData: responseData)
    }
}
