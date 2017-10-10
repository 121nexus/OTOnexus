//
//  OTOReorderResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/10/17.
//

import Foundation

public class OTOReorderResponse : OTOActionResponse {
    var orderQuanty = 0
    
    override func decode(_ responseData: ResponseData) {
        self.orderQuanty = responseData.intValue(forKey: "order_qty")
    }
}
