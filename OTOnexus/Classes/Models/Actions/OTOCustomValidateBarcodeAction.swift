//
//  OTOCustomValidateBarcodeAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/30/17.
//

import Foundation

class OTOCustomValidateBarcodeAction : OTOAction<OTOCustomValidateBarcodeResponse> {
    var barcode = ""
    
    override func bodyParams() -> [String : Any] {
        return ["barcode_data":barcode]
    }
}
