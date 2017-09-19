//
//  Decodeable.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/19/17.
//

import Foundation

protocol Decodable {
    func decode(_ responseObject:ResponseObject)
    static func decode(_ responseObject:ResponseObject) -> Self
    static func array(_ array:[ResponseObject]) -> [Self]
    init()
}

extension Decodable {
    static func decode(_ responseObject:ResponseObject) -> Self {
        let decodable = Self()
        decodable.decode(responseObject)
        return decodable
    }
    
    static func array(_ array:[ResponseObject]) -> [Self] {
        var objects = [Self]()
        for responseObject in array {
            objects.append(decode(responseObject))
        }
        return objects
    }
}
