//
//  WebServiceOperation.swift
//  Pods
//
//  Created by Nicholas Schlueter on 9/15/17.
//
//

import Foundation

class WebServiceOperation: AsyncOperation {
    
    var endPoint = ""
    enum HttpMethod : String {
        case GET, POST, HEAD, DELETE, PUT
    }
    var method:WebServiceOperation.HttpMethod {
        return .GET
    }
    var successBlock:WebServiceManager.SuccessBlock?
    
    override func main() {
        guard let urlRequest = urlRequest() else {
            state = .isFinished
            return
        }
        let dataTask = WebServiceManager.shared.urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.handleSuccess(data: data, response: response)
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
    
    private func dispatchOnMainQueue(_ closure: @escaping @autoclosure () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
}
