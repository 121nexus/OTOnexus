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
    func decode(_ responseObject: ResponseObject) {
        self.id = responseObject.int(forKey: "id")
        self.name = responseObject.string(forKey: "name")
        self.description = responseObject.string(forKey: "description")
    }
}
