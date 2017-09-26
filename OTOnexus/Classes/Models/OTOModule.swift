//
//  Module.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

final public class OTOModule {
    public var submitAction:OTOAction?
}

extension OTOModule : Decodable {
    func decode(_ responseData:ResponseData) {
        if let submit = responseData.responseData(forKey: "actions")?.responseData(forKey: "submit") {
            self.submitAction = OTOAction.decode(submit)
        }
    }
}

