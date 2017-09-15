//
//  GetWebServiceOperation.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
//

import Foundation

class GetWebServiceOperation : WebServiceOperation {
    var queryParams = [String:String]()
    
    override func urlRequest() -> URLRequest? {
        guard var urlRequest = super.urlRequest() else {
            return nil
        }
        var components = URLComponents()
        components.queryItems = queryParams.map {
            URLQueryItem(name: $0, value: $1)
        }
        if let queryUrl = components.url?.absoluteString,
            let fullUrlString = urlRequest.url?.absoluteString,
            let fullUrl = URL(string:fullUrlString + queryUrl){
            urlRequest.url = fullUrl
        }
        return urlRequest
    }
}
