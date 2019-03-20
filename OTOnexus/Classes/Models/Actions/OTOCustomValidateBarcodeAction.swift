//
//  OTOCustomValidateBarcodeAction.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class OTOCustomValidateBarcodeAction : OTOAction<OTOCustomValidateBarcodeResponse> {
    var barcode = ""
    
    override func bodyParams() -> [String : Any] {
        return ["barcode_data":barcode]
    }
}
