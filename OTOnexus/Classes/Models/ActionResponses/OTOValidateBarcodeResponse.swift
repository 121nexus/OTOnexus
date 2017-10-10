//
//  OTOValidateBarcodeResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 10/10/17.
//

import Foundation

public class OTOValidateBarcodeResponse : OTOActionResponse {
    public var validationSuccessful = false
    public var parsingSuccessful = false
    public var parsedAis = [String: String]()
    public var errors = [String: [String]]()
    public var allErrorMessages = [String]()
    
    override func decode(_ responseData: ResponseData) {
        print(responseData)
        
        self.validationSuccessful = responseData.boolValue(forKey: "validation_successful")
        self.parsingSuccessful = responseData.boolValue(forKey: "parsing_successful")
        if let parsedAis = responseData.dictionary(forKey: "parsed_ais") as? [String:String] {
            self.parsedAis = parsedAis
        }
        
        if let errors = responseData.dictionary(forKey: "errors") as? [String: [String]] {
            self.errors = errors
            self.allErrorMessages = self.errors.flatMap({ (error) -> [String] in
                return error.value
            })
        }
    }
}
