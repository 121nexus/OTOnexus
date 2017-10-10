//
//  Experience.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

public class Experience {
    public var id = -1
    public var name = ""
    public var description = ""
    public var productRequired = false
    
    required public init() {
    }
}

extension Experience : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.intValue(forKey: "id")
        self.name = responseData.stringValue(forKey: "name")
        self.description = responseData.stringValue(forKey: "description")
    }
}
