//
//  OTOSurveyQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation
/**
 OTOSurveyQuestion is a question class
 */
public class OTOSurveyQuestion: Decodable {
    var id = ""
    ///Property to hold a question
    public var question = ""
    ///Property defining if a question is required
    public var required = false
    
    /// :nodoc:
    public required init() {
    }
    
    func data() -> String? {
        return nil
    }
    
    func decode(_ responseData: ResponseData) {
        self.id = responseData.stringValue(forKey: "id")
        self.question = responseData.stringValue(forKey: "question")
        if let required = responseData.bool(forKey: "required") {
            self.required = required
        }
    }
}
