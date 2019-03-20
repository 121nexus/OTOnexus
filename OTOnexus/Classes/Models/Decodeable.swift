//
//  Decodeable.swift
//  OTOnexus
//
//  Copyright © 2019 Soom. All rights reserved.
//

import Foundation

protocol Decodable {
    func decode(_ responseData:ResponseData)
    init()
}

extension Decodable {
    static func decode(_ responseData:ResponseData) -> Self {
        let decodable = Self()
        decodable.decode(responseData)
        return decodable
    }
    
    static func array(_ array:[ResponseData]) -> [Self] {
        return array.map { (responseData) -> Self in
            return decode(responseData)
        }
    }
}
