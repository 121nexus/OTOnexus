//
//  Module.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

/**
OTOModule represents an instance of a module. Modules contain functionality associated with a product. For example a video module will present video content about a particular product on the *121nexus platform*.
*/
public class OTOModule : Decodable {
    static private let classMap = ["ImageUpload": OTOImageUploadModule.self,
                                   "Video": OTOVideoModule.self,
                                   "Gudid": OTOGudidModule.self,
                                   "SafetyCheck": OTOSafetyCheckModule.self,
                                   "GS1Validation": OTOGs1ValidationModule.self,
                                   "Reorder": OTOReorderModule.self,
                                   "Text": OTOTextModule.self]
    
    /// Int value identifying a module.
    public var id = 0
    weak var session:OTOSession? {
        didSet {
            for action in actions {
                action.session = self.session
            }
        }
    }
    
    private var actions = [SessionAction]()
    
    public required init() {
    }
    
    private func actionUrl(forName name:String, responseData:ResponseData) -> String? {
        let actionsData = responseData.responseDataValue(forKey: "actions")
        
        return actionsData.string(forKey: name)
    }
    
    func action<T:SessionAction>(forName name:String, responseData:ResponseData) -> T? {
        if let url = actionUrl(forName: name, responseData: responseData) {
            let action = T.init(url: url)
            actions.append(action)
            return action
        }
        return nil
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

