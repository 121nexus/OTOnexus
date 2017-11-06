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
    
    public func reorder(success:@escaping (String) -> Void) {
        reorderAction?.perform(complete: { (reorderResponse, error) in
            if let reorderResponse = reorderResponse {
                success(reorderResponse.orderQuanty)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.orderQuatity = responseData.responseDataValue(forKey: "config").stringValue(forKey: "order_qty")
        
        if let reorderUrl = self.actionUrl(forName: "reorder", responseData: responseData) {
            self.reorderAction = OTOReorderAction(url: reorderUrl)
        }
    }
}
