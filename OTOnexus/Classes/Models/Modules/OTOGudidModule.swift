//
//  OTOGudidModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOGudidModule : OTOModule {
    var lookupAction:OTOLookupAction?

    public func lookup(success:@escaping (OTOLookupSuccessResponse) -> Void, failure:@escaping (OTOLookupFailureResponse) -> Void) {
        lookupAction?.perform(complete: { (response, error) in
            if let lookupSuccessResponse = response as? OTOLookupSuccessResponse {
                success(lookupSuccessResponse)
            } else if let lookupFailureResponse = response as? OTOLookupFailureResponse {
                failure(lookupFailureResponse)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let lookupUrl = self.actionUrl(forName: "lookup", responseData: responseData) {
            self.lookupAction = OTOLookupAction(url: lookupUrl)
        }
    }
}
