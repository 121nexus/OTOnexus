//
//  OTOSurveySubmitAction.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class OTOSurveySubmitAction : OTOAction<OTOActionResponse> {
    var answers = [String]()
    override func bodyParams() -> [String:Any] {
        return ["answers":answers]
    }
}
