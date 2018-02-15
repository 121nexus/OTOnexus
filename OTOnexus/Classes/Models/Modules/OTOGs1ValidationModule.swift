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
    public func validateBarcode(complete: @escaping (OTOValidateBarcodeResponse?, OTOError?) -> Void) {
        if let barcode = session?.barcode {
            validateBarcodeAction?.barcode = barcode.data
        }
        validateBarcodeAction?.perform(complete: { [weak self] (barcodeResponse, error) in
            guard let strongSelf = self else { return }
            if let barcodeResponse = barcodeResponse {
                strongSelf.validationResponse = barcodeResponse
                complete(barcodeResponse, nil)
            } else {
                complete(nil, error)
            }
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.validateBarcodeAction = self.action(forName: "validate_barcode", responseData: responseData)
    }
}
