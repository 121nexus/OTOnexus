//
//  ResponseObject.swift
//  OTOnexus
//
//  Copyright © 2018 Soom. All rights reserved.
//

import Foundation

class ResponseObject {
    var data: ResponseData?
    var statusCode: Int
    var headers:[AnyHashable:Any] = [:]
    var isSuccessful:Bool {
        return self.statusCode >= 200 && self.statusCode < 300
    }
    
    init(data:[String: Any]?, statusCode: Int, headers:[AnyHashable:Any
        ]) {
        if let data = data {
            self.data = ResponseData(data)
        }
        
        self.headers = headers
        
        self.statusCode = statusCode
    }
    
    func dataValue() -> ResponseData {
        if let data = self.data {
            return data
        } else {
            return ResponseData([:])
        }
    }
}
