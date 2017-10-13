//
//  OTOGs1ValidationModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOGs1ValidationModule : OTOModule {
    var validateBarcodeAction:OTOValidateBarcodeAction?
    public var validationResponse:OTOValidateBarcodeResponse?
    
    public func validateBarcode(complete: @escaping (OTOValidateBarcodeResponse) -> Void) {
        if let barcode = session?.product?.barcodeData {
            validateBarcodeAction?.barcode = barcode
        }
        validateBarcodeAction?.perform(complete: { (barcodeResponse, error) in
            if let barcodeResponse = barcodeResponse {
                self.validationResponse = barcodeResponse
                complete(barcodeResponse)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let validateBarcodeUrl = self.actionUrl(forName: "validate_barcode", responseData: responseData) {
            self.validateBarcodeAction = OTOValidateBarcodeAction(url: validateBarcodeUrl)
        }
    }
}
