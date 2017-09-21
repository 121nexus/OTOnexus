//
//  ResponseData.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/21/17.
//

class ResponseData {
    private var storage: [String: Any] = [:]
    
    init(_ storage:[String: Any]) {
        self.storage = storage
    }
    
    func string(forKey key:String) -> String {
        if let string = storage[key] as? String {
            return string
        }
        return ""
    }
    
    func int(forKey key:String) -> Int {
        if let int = storage[key] as? Int {
            return int
        }
        return 0
    }
    
    func bool(forKey key:String) -> Bool {
        if let bool = storage[key] as? Bool {
            return bool
        }
        return false
    }
    
    func array(forKey key:String) -> [ResponseData] {
        if let array = storage[key] as? [[String: Any]] {
            return array.map({ (dictionary) -> ResponseData in
                return ResponseData(dictionary)
            })
        }
        return []
    }
}
