//
//  WebServiceManager.swift
//  OTOnexus
//
//  Copyright © 2017 121nexus. All rights reserved.
//

import Foundation

class WebServiceManager {
    private let operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "OTONexusAPI", attributes: .concurrent)
        return queue
    }()
    enum WebServiceError : Error {
        case errorFromServer(Error)
        case errorWithMessage(String)
        case unauthenticated
    }
    typealias ResponseCompletionBlock = (ResponseObject?, OTOError?) -> Void
    static let shared = WebServiceManager()
    var urlSession:URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    var baseUrl = URL(string: "https://api.soom.com/v3")
    
    func configureWithApiKey(apiKey:String) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
        configuration.httpAdditionalHeaders = ["api-key": apiKey]
        self.urlSession = URLSession(configuration: configuration)
        
    }
    
    func setApiUrl(apiUrl:String) {
        baseUrl = URL(string: "https://\(apiUrl)/v3")
    }
    
    func url(withEndPoint endpoint:String) -> URL? {
        if endpoint.hasPrefix("https") {
            return URL(string:endpoint)
        } else {
            guard let baseUrl = baseUrl else {
                return nil
            }
            return baseUrl.appendingPathComponent(endpoint)
        }
    }
    
    func get(endpoint:String, params:[String:String], completion:@escaping ResponseCompletionBlock) {
        let getOperation = GetWebServiceOperation()
        getOperation.queryParams = params
        getOperation.endPoint = endpoint
        getOperation.responseCompletionBlock = completion
        self.runRequest(operation: getOperation)
    }
    
    func head(endpoint:String, params:[String:String], completion:@escaping ResponseCompletionBlock) {
        let headOperation = HeadWebServiceOperation()
        headOperation.queryParams = params
        headOperation.endPoint = endpoint
        headOperation.responseCompletionBlock = completion
        self.runRequest(operation: headOperation)
    }
    
    func delete(endpoint:String, params:[String:String], completion:@escaping ResponseCompletionBlock) {
        let deleteOperation = DeleteWebServiceOperation()
        deleteOperation.queryParams = params
        deleteOperation.endPoint = endpoint
        deleteOperation.responseCompletionBlock = completion
        self.runRequest(operation: deleteOperation)
    }
    
    func post(endpoint:String, body:[String:Any], completion:@escaping ResponseCompletionBlock) {
        let postOperation = PostWebServiceOperation()
        postOperation.body = body
        postOperation.endPoint = endpoint
        postOperation.responseCompletionBlock = completion
        self.runRequest(operation: postOperation)
    }
    
    func put(endpoint:String, body:[String:String], completion:@escaping ResponseCompletionBlock) {
        let putOperation = PutWebServiceOperation()
        putOperation.body = body
        putOperation.endPoint = endpoint
        putOperation.responseCompletionBlock = completion
        self.runRequest(operation: putOperation)
    }
    
    func runRequest(operation:WebServiceOperation) {
        self.operationQueue.addOperation(operation)
    }
}
