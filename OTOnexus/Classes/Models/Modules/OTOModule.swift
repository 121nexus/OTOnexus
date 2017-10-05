//
//  Module.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

public class OTOModule : Decodable {
    static private let classMap = ["ImageUpload": OTOImageUploadModule.self,
                                   "Video": OTOVideoModule.self,
                                   "Gudid": OTOGudidModule.self,
                                   "SafetyCheck": OTOSafetyCheckModule.self,
                                   "Gs1Validation": OTOGs1ValidationModule.self,
                                   "Reorder": OTOReorderModule.self]
    
    public var id = 0
    
    public required init() {
    }
    
    func populateActions(withUrlBase urlBase:String) {
    }
    
    func actionEndpoint(withUrlBase urlBase:String, actionName:String) -> String {
        return "\(urlBase)/modules/\(id)/\(actionName)"
    }
    
    func decode(_ responseData:ResponseData) {
        self.id = responseData.intValue(forKey: "id")
    }
    
    static func array(_ array:[ResponseData]) -> [OTOModule] {
        var modules = [OTOModule]()
        for responseData in array {
            if let objectType = classMap[responseData.stringValue(forKey: "type")] {
                let instance = objectType.init()
                instance.decode(responseData)
                modules.append(instance)
            }
        }
        return modules
    }
}

