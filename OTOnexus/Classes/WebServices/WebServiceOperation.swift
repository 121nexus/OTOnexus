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
    var successBlock:WebServiceManager.SuccessBlock?
    
    required override init() {
    }
    
    override func main() {
        guard let urlRequest = urlRequest() else {
            state = .isFinished
            return
        }
        let dataTask = WebServiceManager.shared.urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.handleSuccess(data: data, response: response)
            } else {
                self.handleError(response: response as? HTTPURLResponse, error: error)
            }
            self.state = .isFinished
        }
        dataTask.resume()
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
    
    private func handleSuccess(data:Data?, response:HTTPURLResponse) {
        guard let successBlock = successBlock,
            let data = data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data,
                                                                  options: []),
            let jsonDictionary = json as? [String: Any] {
            if let dataDictionary = jsonDictionary["data"] as? [String: Any] {
                dispatchOnMainQueue(successBlock(ResponseObject(data: dataDictionary)))
            } else {
                dispatchOnMainQueue(successBlock(nil))
            }
        }
    }
    
    private func handleError(response:HTTPURLResponse?, error:Error?) {
        if let nsError = error as NSError?,
            self.canRetry(error: nsError),
            self.retry < 3 {
            self.retryOperation()
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
        operation.retry = retry + 1
        operation.successBlock = successBlock
        
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
