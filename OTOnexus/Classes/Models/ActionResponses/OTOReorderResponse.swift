//
//  OTOReorderResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/10/17.
//

import Foundation

public class OTOReorderResponse : OTOActionResponse {
    var orderQuanty = ""
    
    override func decode(_ responseData: ResponseData) {
        self.orderQuanty = responseData.stringValue(forKey: "order_qty")
    }
}
