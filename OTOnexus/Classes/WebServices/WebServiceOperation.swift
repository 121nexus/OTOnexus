//
//  WebServiceOperation.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
//

import Foundation

class WebServiceOperation: AsyncOperation {
    private var retry = 0
    var endPoint = ""
    enum HttpMethod : String {
        case GET, POST, HEAD, DELETE, PUT
    }
    var method:WebServiceOperation.HttpMethod {
        return .GET
    }
    var responseCompletionBlock: WebServiceManager.ResponseCompletionBlock?
    
    required override init() {
    }
    
    override func main() {
        guard let urlRequest = urlRequest() else {
            state = .isFinished
            return
        }
        let dataTask = WebServiceManager.shared.urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                let strongSelf = self else { return }
            let responseObject = strongSelf.responseObject(forData: data, response: response)
            
            if response.statusCode >= 200 && response.statusCode < 300 {
                if let responseCompletionBlock = strongSelf.responseCompletionBlock {
                    strongSelf.dispatchOnMainQueue(responseCompletionBlock(responseObject, nil))
                }
            } else {
                strongSelf.handleError(response: response, error: error, responseObject: responseObject)
            }
            
            strongSelf.state = .isFinished
        }
        dataTask.resume()
    }
    
    private func responseObject(forData data:Data?, response: HTTPURLResponse) -> ResponseObject {
        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data,
                                                        options: []),
            let jsonDictionary = json as? [String: Any] {
            return ResponseObject(data: jsonDictionary,
                                  statusCode: response.statusCode,
                                  headers: response.allHeaderFields)
        }
        return ResponseObject(data: nil,
                              statusCode: response.statusCode,
                              headers: response.allHeaderFields)
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = WebServiceManager.shared.url(withEndPoint: endPoint) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        return urlRequest
    }
    
    private func handleError(response:HTTPURLResponse?, error:Error?, responseObject:ResponseObject) {
        if let nsError = error as NSError?,
            self.canRetry(error: nsError),
            self.retry < 3 {
            self.retryOperation()
        } else if let responseCompletionBlock = responseCompletionBlock {
            if let error = error {
                dispatchOnMainQueue(responseCompletionBlock(nil,.errorFromServer(error)))
            } else if responseObject.statusCode == 401 {
                dispatchOnMainQueue(responseCompletionBlock(nil,.unauthenticated))
            } else if let message = responseObject.dataValue().string(forKey: "message") {
                dispatchOnMainQueue(responseCompletionBlock(nil,.errorWithMessage(message)))
            } else {
                dispatchOnMainQueue(responseCompletionBlock(nil,.errorWithMessage("An unknown error has occured")))
            }
        }
    }
    
    private func dispatchOnMainQueue(_ closure: @escaping @autoclosure () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    private func retryOperation() {
        WebServiceManager.shared.runRequest(operation: self.duplicateOperation())
    }
    
    func duplicateOperation() -> WebServiceOperation {
        let operation = type(of: self).init()
        operation.endPoint = self.endPoint
        operation.retry = self.retry + 1
        operation.responseCompletionBlock = self.responseCompletionBlock
        
        return operation
    }
    
    private func canRetry(error:NSError) -> Bool {
        return (error.code == NSURLErrorCancelled) ||
            (error.code == NSURLErrorTimedOut) ||
            (error.code == NSURLErrorCannotFindHost) ||
            (error.code == NSURLErrorCannotConnectToHost) ||
            (error.code == NSURLErrorDNSLookupFailed) ||
            (error.code == NSURLErrorNetworkConnectionLost) ||
            (error.code == NSURLErrorNotConnectedToInternet)
    }
}
