//
//  OTOSurveyTextQuestion.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

public class OTOSurveyTextQuestion: OTOSurveyQuestion {
    ///Value of an answer to a Text question
    public var response:String?
    
    override func data() -> String? {
        return response
    }
}
