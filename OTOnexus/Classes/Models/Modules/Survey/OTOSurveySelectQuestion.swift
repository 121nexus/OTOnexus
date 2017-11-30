//
//  OTOSurveySelectQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveySelectQuestion: OTOSurveyQuestion {
    ///Value of answers to select from
    public var answers = [String]()
    ///Value of the answer selected
    public var selection:String?
    
    override func data() -> String? {
        return selection
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        if let answers = responseData.objectArray(forKey: "answers") as? [String] {
            self.answers = answers
        }
    }
}
