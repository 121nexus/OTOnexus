//
//  OTOGs1ValidationModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/5/17.
//

import Foundation

/**
 OTOGs1ValidationModule is a module that validates barcode data based on GS1's barcode parsing rules. [GS1 General Spec](https://www.gs1.org/docs/barcodes/GS1_General_Specifications.pdf)
 */
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
