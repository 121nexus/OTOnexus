//
//  Decodeable.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/19/17.
//

import Foundation

protocol Decodable {
    func decode(_ responseData:ResponseData)
    static func decode(_ responseData:ResponseData) -> Self
    static func array(_ array:[ResponseData]) -> [Self]
    init()
}

extension Decodable {
    static func decode(_ responseData:ResponseData) -> Self {
        let decodable = Self()
        decodable.decode(responseData)
        return decodable
    }
    
    static func array(_ array:[ResponseData]) -> [Self] {
        var objects = [Self]()
        for responseData in array {
            objects.append(decode(responseData))
        }
        return objects
    }
}
