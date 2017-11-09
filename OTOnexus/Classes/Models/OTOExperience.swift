//
//  OTOExperience.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

/**
The OTOExperience class defines an experience of a scanned product. Experiences are comprised of one or more modules that a user can interact with. Experiences let users watch video, upload photos, validate data and display content.
*/
public class OTOExperience {
    /// id given to an experience
    public var id = -1
    /// Name of the experience
    public var name = ""
    /// Description given to experience (i.e. "GS1 validation experience for manufacturer")
    public var description = ""
    private var productRequired = false
    
    required public init() {
    }
}

extension OTOExperience : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.intValue(forKey: "id")
        self.name = responseData.stringValue(forKey: "name")
        self.description = responseData.stringValue(forKey: "description")
    }
}
