//
//  OTOSurveySubmitAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 11/28/17.
//

import Foundation

class OTOSurveySubmitAction : OTOAction<OTOActionResponse> {
    var answers = [String]()
    override func bodyParams() -> [String:Any] {
        return ["answers":answers]
    }
}
