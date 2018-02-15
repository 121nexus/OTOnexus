//
//  OTOCustomValidationModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/28/17.
//

import Foundation

/**
 OTOCustomValidationModule is a module that allows a user to run custom validations on barcodes with rules created on the *121nexus Platform*.
 */
public class OTOCustomValidationModule : OTOModule {
    var validateBarcodeAction:OTOCustomValidateBarcodeAction?
    /**
     Response object returned from custom validation
     */
    public var validationResponse:OTOCustomValidateBarcodeResponse?
    
    /// Function to validate barcode data using custom validation rules
    public func validateBarcode(complete: @escaping (OTOCustomValidateBarcodeResponse?, OTOError?) -> Void) {
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
