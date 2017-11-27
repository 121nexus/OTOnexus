//
//  OTOSurveyDateQuestion.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/27/17.
//

import Foundation

public class OTOSurveyDateQuestion: OTOSurveyQuestion {
    var date:Date?
    
    override func data() -> Any? {
        if let date = self.date {
            return OTODateHelper.shared.yearMonthDayParser.string(from: date)
        } else {
            return nil
        }
    }
}
