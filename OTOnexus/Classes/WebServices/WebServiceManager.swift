//
//  WebServiceManager.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
//

import Foundation

class WebServiceManager {
    private let operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "OTONexusAPI", attributes: .concurrent)
        return queue
    }()
    typealias SuccessBlock = (ResponseObject?) -> Void
    typealias FailureBlock = (Error?) -> Void
    static let shared = WebServiceManager()
    var urlSession = URLSession(configuration: .default)
    var baseUrl = URL(string: "https://private-4304e4-121nexus.apiary-mock.com/v3")
    
    func url(withEndPoint endpoint:String) -> URL? {
        guard let baseUrl = baseUrl else {
            return nil
        }
        return baseUrl.appendingPathComponent(endpoint)
    }
    
    func get(endpoint:String, params:[String:String], success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let getOperation = GetWebServiceOperation()
        getOperation.queryParams = params
        getOperation.endPoint = endpoint
        getOperation.successBlock = success
        self.operationQueue.addOperation(getOperation)
    }
    
    func head(endpoint:String, params:[String:String], success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let headOperation = HeadWebServiceOperation()
        headOperation.queryParams = params
        headOperation.endPoint = endpoint
        headOperation.successBlock = success
        self.operationQueue.addOperation(headOperation)
    }
    
    func delete(endpoint:String, params:[String:String], success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let deleteOperation = DeleteWebServiceOperation()
        deleteOperation.queryParams = params
        deleteOperation.endPoint = endpoint
        deleteOperation.successBlock = success
        self.operationQueue.addOperation(deleteOperation)
    }
    
    func post(endpoint:String, body:[String:Any], success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let postOperation = PostWebServiceOperation()
        postOperation.body = body
        postOperation.endPoint = endpoint
        postOperation.successBlock = success
        self.operationQueue.addOperation(postOperation)
    }
    
    func put(endpoint:String, body:[String:String], success:@escaping SuccessBlock, failure:@escaping FailureBlock) {
        let putOperation = PutWebServiceOperation()
        putOperation.body = body
        putOperation.endPoint = endpoint
        putOperation.successBlock = success
        self.operationQueue.addOperation(putOperation)
    }
}
