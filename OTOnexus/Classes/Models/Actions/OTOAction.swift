//
//  OTOAction.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/26/17.
//

import Foundation

class OTOAction<ResponseType: OTOActionResponse> {
    typealias CompletionClosure = (ResponseType?, OTOError?) -> Void
    let url:String
    
    public init(url:String) {
        self.url = url
    }
    
    func perform(complete: @escaping CompletionClosure) {
        WebServiceManager.shared.post(endpoint: url,
                                      body: self.bodyParams()) { (responseObject, error) in
                                        if let responseObject = responseObject {
                                            complete(self.process(responseObject: responseObject), nil)
                                        } else {
                                            complete(nil, error)
                                        }
        }
    }
    
    func process(responseObject:ResponseObject) -> ResponseType? {
        return ResponseType.decode(responseObject.dataValue())
    }
    
    func bodyParams() -> [String: Any] {
        return [:]
    }
}
