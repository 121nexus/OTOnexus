//
//  OTOSafetyCheckModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOSafetyCheckModule : OTOModule {
    private var safetyCheckAction:OTOCheckSafetyAction?
    private var safetyResult:Bool?
    
    private func checkSafety(success:@escaping (Bool) -> Void) {
        safetyCheckAction?.perform(complete: { (checkSafetyResponse, error) in
            if let checkSafetyResponse = checkSafetyResponse {
                self.safetyResult = checkSafetyResponse.safe
                success(checkSafetyResponse.safe)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let checkSafetyUrl = self.actionUrl(forName: "check_safety", responseData: responseData) {
            self.safetyCheckAction = OTOCheckSafetyAction(url: checkSafetyUrl)
        }
    }
}
