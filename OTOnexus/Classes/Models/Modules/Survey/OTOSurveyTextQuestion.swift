//
//  OTOSurveyTextQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveyTextQuestion: OTOSurveyQuestion {
    ///Value of an answer to a Text question
    public var response:String?
    
    override func data() -> String? {
        return response
    }
}
