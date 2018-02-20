//
//  OTOReorderResponse.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

public class OTOReorderResponse : OTOActionResponse {
    var orderQuanty = ""
    
    override func decode(_ responseData: ResponseData) {
        self.orderQuanty = responseData.stringValue(forKey: "order_qty")
    }
}
