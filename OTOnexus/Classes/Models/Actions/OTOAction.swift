//
//  OTOAction.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import Foundation

protocol SessionAction: class {
    weak var session:OTOSession? {get set}
    init(url:String)
}

class OTOAction<ResponseType: OTOActionResponse> {
    typealias CompletionClosure = (ResponseType?, OTOError?) -> Void
    let url:String
    weak var session:OTOSession?
    
    required init(url:String) {
        self.url = url
    }
    
    func perform(complete: @escaping CompletionClosure) {
        WebServiceManager.shared.post(endpoint: url,
                                      body: self.bodyParams()) { [weak self] (responseObject, error) in
                                        guard let strongSelf = self else { return }
                                        if let responseObject = responseObject {
                                            if let transition = responseObject.headers["X-Transition"] as? String {
                                                if transition == "true" {
                                                    strongSelf.session?.getLatestSessionData()
                                                }
                                            }
                                            complete(strongSelf.process(responseObject: responseObject), nil)
                                        } else {
                                            complete(nil, error)
                                        }
        }
    }
    
    func process(responseObject:ResponseObject) -> ResponseType? {
        return ResponseType.decode(responseObject.dataValue())
    }
    
    func bodyParams() -> [String:Any] {
        return [:]
    }
}

extension OTOAction: SessionAction {
}
