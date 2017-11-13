//
//  OTOGudidModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

/**
 OTOGudidModule is a module that allows users to look up medical devices via barcode data in the FDA's GUDID access database. It provides information about a medical device submitted to the FDA by the manufacturer.
 */
public class OTOGudidModule : OTOModule {
    var lookupAction:OTOLookupAction?
    
    /// Successful response object returned for a FDA GUDID lookup
    public var lookupSuccessResponse:OTOLookupSuccessResponse?
    /// Failure response object returned for a FDA GUDID lookup
    public var lookupFailureResponse:OTOLookupFailureResponse?
    
    /// FDA GUDID lookup function
    public func lookup(complete:@escaping (OTOLookupResponse?, OTOError?) -> Void) {
        lookupAction?.perform(complete: { [weak self]  (response, error) in
            guard let strongSelf = self else { return }
            if let lookupSuccessResponse = response as? OTOLookupSuccessResponse {
                strongSelf.lookupSuccessResponse = lookupSuccessResponse
                complete(lookupSuccessResponse, nil)
            } else if let lookupFailureResponse = response as? OTOLookupFailureResponse {
                strongSelf.lookupFailureResponse = lookupFailureResponse
                complete(lookupFailureResponse, nil)
            } else {
                complete(nil, error)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.lookupAction = self.action(forName: "lookup", responseData: responseData)
    }
}

