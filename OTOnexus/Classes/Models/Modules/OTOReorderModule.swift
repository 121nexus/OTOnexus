//
//  OTOReorderModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOReorderModule : OTOModule {
    private var reorderAction:OTOReorderAction?
    public var orderQuatity = ""
    
    public func reorder(complete:@escaping (String?, OTOError?) -> Void) {
        reorderAction?.perform(complete: { (reorderResponse, error) in
            if let reorderResponse = reorderResponse {
                complete(reorderResponse.orderQuanty, nil)
            } else {
                complete(nil, error)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.orderQuatity = responseData.responseDataValue(forKey: "config").stringValue(forKey: "order_qty")
        self.reorderAction = self.action(forName: "reorder", responseData: responseData)
    }
}
