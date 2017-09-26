//
//  OTOAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

final public class OTOAction {
    var url = ""
    
    public func perform(success: @escaping () -> Void) {
        WebServiceManager.shared.post(endpoint: url,
                                      body: [:]) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            print(responseObject.data.stringValue(forKey: "message"))
                                        }
        }
    }
}

extension OTOAction : Decodable {
    func decode(_ responseData:ResponseData) {
        self.url = responseData.stringValue(forKey: "url")
    }
}
