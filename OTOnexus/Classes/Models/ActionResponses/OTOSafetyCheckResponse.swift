//
//  OTOSafetyCheckResponse.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

public class OTOSafetyCheckResponse : OTOActionResponse {
    var safe = false
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        self.safe = responseData.string(forKey: "safety_status") == "safe"
    }
}
