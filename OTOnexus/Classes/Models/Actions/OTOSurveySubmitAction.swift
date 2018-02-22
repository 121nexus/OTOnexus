//
//  OTOSurveySubmitAction.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

class OTOSurveySubmitAction : OTOAction<OTOActionResponse> {
    var answers = [String]()
    override func bodyParams() -> [String:Any] {
        return ["answers":answers]
    }
}
