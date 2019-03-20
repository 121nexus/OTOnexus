//
//  GetWebServiceOperation.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class GetWebServiceOperation : WebServiceOperation {
    var queryParams = [String:String]()
 
    override func urlRequest() -> URLRequest? {
        guard var urlRequest = super.urlRequest() else {
            return nil
        }
        
        let generalDelimitersToEncode = ":#[]@/"
        let subDelimitersToEncode = "!$&'()*+,;=."
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        let pairs = queryParams.map { (item) -> String in
            guard let value = item.value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)?
                .replacingOccurrences(of: "%0A", with: "\n")
                .replacingOccurrences(of: "%0D", with: "\r") else { return "\(item.key)="}
            return "\(item.key)=\(value)"
        }
        
        let queryString = "?" + pairs.joined(separator: "&")
        
        if let fullUrlString = urlRequest.url?.absoluteString,
            let fullUrl = URL(string:fullUrlString + queryString){
            urlRequest.url = fullUrl
        }
        return urlRequest
    }
    
    override func duplicateOperation() -> WebServiceOperation {
        let operation = super.duplicateOperation()
        
        if let getOperation = operation as? GetWebServiceOperation {
            getOperation.queryParams = self.queryParams
        }
        
        return operation
    }
}
