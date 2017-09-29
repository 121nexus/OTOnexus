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
    
    func stringValue(forKey key:String) -> String {
        return self.string(forKey: key) ?? ""
    }
    
    func string(forKey key:String) -> String? {
        return storage[key] as? String
    }
    
    func intValue(forKey key:String) -> Int {
        return self.int(forKey: key) ?? 0
    }
    
    func int(forKey key:String) -> Int? {
        return storage[key] as? Int
    }
    
    func boolValue(forKey key:String) -> Bool {
        return self.bool(forKey: key) ?? false
    }
    
    func bool(forKey key:String) -> Bool? {
        return storage[key] as? Bool
    }
    
    func arrayValue(forKey key:String) -> [ResponseData] {
        return self.array(forKey: key) ?? []
    }
    
    func array(forKey key:String) -> [ResponseData]? {
        if let array = storage[key] as? [[String: Any]] {
            return array.map({ (dictionary) -> ResponseData in
                return ResponseData(dictionary)
            })
        }
        return nil
    }
    
    func responseDataValue(forKey key:String) -> ResponseData {
        return self.responseData(forKey: key) ?? ResponseData([:])
    }
    
    func responseData(forKey key:String) -> ResponseData? {
        if let dictionary = storage[key] as? [String: Any] {
            return ResponseData(dictionary)
        }
        return nil
    }
    
    func keys() -> LazyMapCollection<[String : Any], String> {
        return self.storage.keys
    }
}
