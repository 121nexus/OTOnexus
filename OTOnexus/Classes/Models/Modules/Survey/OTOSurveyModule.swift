//
//  OTOSurveyModule.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

/**
 OTOSurveyModule is a module that allows users to present survey type content. There are 3 types of survey questions: Select, Text, and Date.
 */
public class OTOSurveyModule : OTOModule {
    static private let questionClassMap = ["select": OTOSurveySelectQuestion.self,
                                   "text": OTOSurveyTextQuestion.self,
                                   "date": OTOSurveyDateQuestion.self]
    
    ///Property to store prompt text.
    public var promptText = ""
    ///Property to store thank you text
    public var thanksText = ""
    ///Property to hold survey question value
    public var questions = [OTOSurveyQuestion]()
    ///Submit action for survey
    var submitAction:OTOSurveySubmitAction?
    
    ///Method for submitting the results of a set of survey questions
    public func submitSurvey(complete:@escaping (OTOError?) -> Void) {
        let answers = self.questions.map { (question) -> String in
            return question.data() ?? ""
        }
        submitAction?.answers = answers
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
