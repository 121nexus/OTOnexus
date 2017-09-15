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
        queue.underlyingQueue = DispatchQueue(label: "operationQueue", attributes: .concurrent)
        return queue
    }()
    typealias SuccessBlock = ([String: Any]?) -> Void
    static let shared = WebServiceManager()
    var urlSession = URLSession(configuration: .default)
    var baseUrl = URL(string: "https://google.com")
    
    func url(withEndPoint endpoint:String) -> URL? {
        guard let baseUrl = baseUrl else {
            return nil
        }
        return baseUrl.appendingPathComponent(endpoint)
    }
    
    func get(endpoint:String, params:[String:String], success:@escaping SuccessBlock) {
        let getOperation = GetWebServiceOperation()
        getOperation.queryParams = params
        getOperation.endPoint = endpoint
        getOperation.successBlock = success
        self.operationQueue.addOperation(getOperation)
    }
}
