//
//  OTOCustomValidateBarcodeResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/30/17.
//

import Foundation

public class OTOCustomValidateBarcodeResponse : OTOValidateBarcodeResponse {
    public var validationResults:[String:String]?
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let validationResults = responseData.dictionary(forKey: "validation_results") as? [String : String] {
            self.validationResults = validationResults
        }
    }
}
