//
//  OTOSurveyQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveyQuestion: Decodable {
    var id = ""
    public var question = ""
    public var required = false
    
    public required init() {
    }
    
    func data() -> Any? {
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
