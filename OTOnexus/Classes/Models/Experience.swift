//
//  Experience.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/14/17.
//  Copyright © 2017 121Nexus. All rights reserved.
//

import Foundation

final public class Experience {
    var id = -1
    public var name = ""
    public var description = ""
    public var productRequired = false
    
    required public init() {
    }
}

extension Experience : Decodable {
    func decode(_ responseData:ResponseData) {
        self.id = responseData.int(forKey: "id")
        self.name = responseData.string(forKey: "name")
        self.description = responseData.string(forKey: "description")
    }
}
