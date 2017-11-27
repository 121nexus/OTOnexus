//
//  OTOSurveyTextQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveyTextQuestion: OTOSurveyQuestion {
    public var response:String?
    
    override func data() -> Any? {
        return response
    }
    
    override func decode(_ responseData: ResponseData) {
        
    }
}
