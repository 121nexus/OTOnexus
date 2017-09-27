//
//  Module.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

public class OTOModule : Decodable {
    static private let classMap = ["Image": OTOImageUploadModule.self]
    public var submitAction:OTOAction?
    
    public required init() {
    }
    
    func decode(_ responseData:ResponseData) {
        if let submit = responseData.responseData(forKey: "actions")?.responseData(forKey: "submit") {
            self.submitAction = OTOAction.decode(submit)
        }
    }
    
    static func array(_ array:[ResponseData]) -> [OTOModule] {
        return array.map({ (responseData) -> OTOModule in
            if let objectType = classMap[responseData.stringValue(forKey: "type")] {
                return objectType.decode(responseData)
            } else {
                return OTOModule.decode(responseData)
            }
        })
    }
}

