//
//  OTOCustomValidateBarcodeResponse.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

public class OTOCustomValidateBarcodeResponse : OTOValidateBarcodeResponse {
    ///Dictionay of validated results
    public var validationResults:[String:String]?
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        if let validationResults = responseData.dictionary(forKey: "validation_results") as? [String : String] {
            self.validationResults = validationResults
        }
    }
}
