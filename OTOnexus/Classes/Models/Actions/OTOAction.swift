//
//  OTOAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

class OTOAction<ResponseType: OTOActionResponse> {
    typealias CompletionClosure = (ResponseType?, Error?) -> Void
    var url = ""
    
    public required init() {
    }
    
    func perform(complete: @escaping CompletionClosure) {
        let params = ["action_arguments": self.actionArguments()]
        WebServiceManager.shared.post(endpoint: url,
                                      body: params) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            complete(self.process(responseObject: responseObject), nil)
                                        } else {
                                            complete(nil, error)
                                        }
        }
    }
    
    func process(responseObject:ResponseObject) -> ResponseType? {
        // override and don't call super
        return nil
    }
    
    func actionArguments() -> [String: Any] {
        return [:]
    }
}

extension OTOAction : Decodable {
    func decode(_ responseData:ResponseData) {
        self.url = responseData.stringValue(forKey: "url")
    }
}
