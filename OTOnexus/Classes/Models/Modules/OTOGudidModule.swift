//
//  OTOGudidModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOGudidModule : OTOModule {
    var lookupAction:OTOLookupAction?

    public func lookup(success:@escaping (OTOLookupResponse) -> Void) {
        lookupAction?.perform(complete: { (response, error) in
            if let lookupResponse = response {
                success(lookupResponse)
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
