//
//  PostWebServiceOperation.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/18/17.
//

import Foundation

class PostWebServiceOperation : WebServiceOperation {
    var body:[String:Any] = [:]
    override var method:WebServiceOperation.HttpMethod {
        return .POST
    }
    
    override func urlRequest() -> URLRequest? {
        guard var urlRequest = super.urlRequest() else { return nil }
        
        if let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            urlRequest.httpBody = data
        }
        return urlRequest
    }
    
    override func duplicateOperation() -> WebServiceOperation {
        let operation = super.duplicateOperation()
        
        if let postOperation = operation as? PostWebServiceOperation {
            postOperation.body = self.body
        }
        
        return operation
    }
}
