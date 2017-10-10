//
//  OTOValidateBarcodeAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/10/17.
//

import Foundation

class OTOValidateBarcodeAction : OTOAction<OTOValidateBarcodeResponse> {
    var barcode = ""
    
    override func bodyParams() -> [String : Any] {
        return ["gs1_barcode":barcode]
    }
}
