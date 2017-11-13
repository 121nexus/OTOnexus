//
//  OTOSafetyCheckModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOSafetyCheckModule : OTOModule {
    private var safetyCheckAction:OTOCheckSafetyAction?
    public var safetyResult:Bool?
    
    public func checkSafety(complete:@escaping (Bool?, OTOError?) -> Void) {
        safetyCheckAction?.perform(complete: { (checkSafetyResponse, error) in
            if let checkSafetyResponse = checkSafetyResponse {
                self.safetyResult = checkSafetyResponse.safe
                complete(checkSafetyResponse.safe, nil)
            } else {
                complete(nil, error)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.safetyCheckAction = self.action(forName: "check_safety", responseData: responseData)
    }
}
