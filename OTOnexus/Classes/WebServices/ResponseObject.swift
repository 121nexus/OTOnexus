//
//  ResponseObject.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/19/17.
//

import Foundation

class ResponseObject {
    var data: [String: Any] = [:]
    
    init(data:[String: Any]) {
        self.data = data
    }
    
    func string(forKey key:String) -> String {
        if let string = data[key] as? String {
            return string
        }
        return ""
    }
    
    func int(forKey key:String) -> Int {
        if let int = data[key] as? Int {
            return int
        }
        return 0
    }
    
    func bool(forKey key:String) -> Bool {
        if let bool = data[key] as? Bool {
            return bool
        }
        return false
    }
    
    func array(forKey key:String) -> [ResponseObject] {
        if let array = data[key] as? [[String: Any]] {
            return array.map({ (dictionary) -> ResponseObject in
                return ResponseObject(data: dictionary)
            })
        }
        return []
    }
}
