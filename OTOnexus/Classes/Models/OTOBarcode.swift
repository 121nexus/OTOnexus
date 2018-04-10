//
//  OTOBarcode.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import UIKit

/**
 A container object for meta ata about a barcode.
 */
public struct OTOBarcode: Equatable {
    /// actual data in the scanned barcode
    public var data: String
    /// the type of barcode scanned (code128, stacked, QRCode, etc)
    public var type: OTOBarcodeType
    /// autocaptured image of scanned barcode
    public var image: UIImage?

    /// programatically create barcodes
    public init(data: String, type: OTOBarcodeType) {
        self.data = data
        self.type = type
    }
}

extension OTOBarcode: Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return "\(type.code()):\(data)".hashValue
    }
}

/// :nodoc:
public func ==(lhs: OTOBarcode, rhs: OTOBarcode) -> Bool {
    return lhs.data == rhs.data && lhs.type.code() == rhs.type.code()
}
