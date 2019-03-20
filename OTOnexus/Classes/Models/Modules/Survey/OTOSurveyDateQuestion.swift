//
//  OTOSurveyDateQuestion.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

public class OTOSurveyDateQuestion: OTOSurveyQuestion {
    ///Value of an answer to a Date question 
    public var date:Date?
    
    override func data() -> String? {
        if let date = self.date {
            return OTODateHelper.shared.yearMonthDayParser.string(from: date)
        } else {
            return nil
        }
    }
}
