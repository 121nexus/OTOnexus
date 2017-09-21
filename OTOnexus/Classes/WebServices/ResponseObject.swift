//
//  ResponseObject.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/19/17.
//

import Foundation

class ResponseObject {
    var data: ResponseData
    
    init(_ data:[String: Any]) {
        self.data = ResponseData(data)
    }
}
