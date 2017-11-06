//
//  OTOGs1ValidationModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

public class OTOGs1ValidationModule : OTOModule {
    var validateBarcodeAction:OTOValidateBarcodeAction?
    /**
     Response object returned from GS1 validation
    */
    public var validationResponse:OTOValidateBarcodeResponse?
    
    /// Function to validate barcode data using GS1 validation rules
    public func validateBarcode(complete: @escaping (OTOValidateBarcodeResponse) -> Void) {
        if let barcode = session?.barcode {
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
