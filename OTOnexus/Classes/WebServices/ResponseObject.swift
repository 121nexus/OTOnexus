//
//  ResponseObject.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/19/17.
//

import Foundation

class ResponseObject {
    var data: ResponseData?
    var statusCode: Int
    var isSuccessful:Bool {
        return self.statusCode >= 200 && self.statusCode < 300
    }
    
    init(data:[String: Any]?, statusCode: Int) {
        if let data = data {
            self.data = ResponseData(data)
        }
        
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
