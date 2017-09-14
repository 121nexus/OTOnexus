//
//  Session.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

class Session {
    var sessionid = ""
    var productUrl = ""
    
    static func startSession(withExperience experience:Experience,
                             complete: (Session) -> Void) {
        // TODO: call POST /v3/experiences/{experience_id}/sessions
    }
}
