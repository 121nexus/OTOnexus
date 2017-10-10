//
//  OTOReorderModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOReorderModule : OTOModule {
    private var reorderAction:OTOReorderAction?
    
    public func reorder(success:@escaping (Int) -> Void) {
        reorderAction?.perform(complete: { (reorderResponse, error) in
            if let reorderResponse = reorderResponse {
                success(reorderResponse.orderQuanty)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let reorderUrl = self.actionUrl(forName: "reorder", responseData: responseData) {
            self.reorderAction = OTOReorderAction(url: reorderUrl)
        }
    }
}
