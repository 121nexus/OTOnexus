//
//  OTOSurveySelectQuestion.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
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
