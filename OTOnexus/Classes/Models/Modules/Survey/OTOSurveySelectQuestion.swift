//
//  OTOSurveySelectQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveySelectQuestion: OTOSurveyQuestion {
    public var answers = [String]()
    public var selection:String?
    
    override func data() -> Any? {
        return selection
    }
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        if let answers = responseData.objectArray(forKey: "answers") as? [String] {
            self.answers = answers
        }
    }
}
