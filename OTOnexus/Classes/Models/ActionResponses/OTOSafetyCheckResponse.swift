//
//  OTOSafetyCheckResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/10/17.
//

import Foundation

public class OTOSafetyCheckResponse : OTOActionResponse {
    var safe = false
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        self.safe = responseData.string(forKey: "safety_status") == "safe"
    }
}
