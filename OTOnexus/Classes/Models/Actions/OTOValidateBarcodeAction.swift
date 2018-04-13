//
//  OTOValidateBarcodeAction.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class OTOValidateBarcodeAction : OTOAction<OTOValidateBarcodeResponse> {
    var barcode = ""
    
    override func bodyParams() -> [String : Any] {
        return ["barcode_data":barcode]
    }
}
