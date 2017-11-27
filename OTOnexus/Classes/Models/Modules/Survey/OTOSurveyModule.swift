//
//  OTOSurveyModule.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveyModule : OTOModule {
    static private let questionClassMap = ["select": OTOSurveySelectQuestion.self,
                                   "text": OTOSurveyTextQuestion.self,
                                   "date": OTOSurveyDateQuestion.self]
    
    public var promptText = ""
    public var thanksText = ""
    public var questions = [OTOSurveyQuestion]()
    
    override func decode(_ responseData: ResponseData) {
        self.promptText = responseData.stringValue(forKey: "prompt_text")
        self.thanksText = responseData.stringValue(forKey: "thanks_text")
        
        for question in responseData.arrayValue(forKey: "questions") {
            if let objectType = OTOSurveyModule.questionClassMap[question.stringValue(forKey: "answer_type")] {
                let instance = objectType.init()
                instance.decode(responseData)
                questions.append(instance)
            }
        }
    }
}
