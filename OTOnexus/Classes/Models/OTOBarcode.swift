//
//  OTOBarcode.swift
//  OTOnexus
//
//  Created by Andrew McKnight on 2/14/18.
//

import UIKit

public struct OTOBarcode: Equatable {
    public var data: String
    public var type: OTOBarcodeType
    public var image: UIImage?

    init(data: String, type: OTOBarcodeType) {
        self.data = data
        self.type = type
    }
}

extension OTOBarcode: Hashable {
    public var hashValue: Int {
        return "\(type.code()):\(data)".hashValue
    }
}

public func ==(lhs: OTOBarcode, rhs: OTOBarcode) -> Bool {
    return lhs.data == rhs.data && lhs.type.code() == rhs.type.code()
}
