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
    
    var submitAction:OTOSurveySubmitAction?
    
    public func submitSurvey(complete:@escaping (OTOError?) -> Void) {
        submitAction?.perform(complete: { (response, error) in
            complete(error)
        })
    }
    
    override func decode(_ responseData: ResponseData) {
        let config = responseData.responseDataValue(forKey: "config")
        self.promptText = config.stringValue(forKey: "prompt_text")
        self.thanksText = config.stringValue(forKey: "thanks_text")
        
        for question in config.arrayValue(forKey: "questions") {
            if let objectType = OTOSurveyModule.questionClassMap[question.stringValue(forKey: "answer_type")] {
                let instance = objectType.init()
                instance.decode(question)
                questions.append(instance)
            }
        }
        
        self.submitAction = self.action(forName: "submit", responseData: responseData)
    }
}
