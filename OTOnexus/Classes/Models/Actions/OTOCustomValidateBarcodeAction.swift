//
//  OTOCustomValidateBarcodeAction.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class OTOCustomValidateBarcodeAction : OTOAction<OTOCustomValidateBarcodeResponse> {
    var barcode = ""
    
    override func bodyParams() -> [String : Any] {
        return ["barcode_data":barcode]
    }
}
