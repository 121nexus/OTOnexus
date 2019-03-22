//
//  OTOBarcodeType.swift
//  OTOnexus
//
//  Copyright © 2019 Soom. All rights reserved.
//

import AVFoundation
import Foundation

private let stackedRawStringSeparator: String = ","
private let QRCodeName = "QR Code"
private let dataMatrixName = "DataMatrix"
private let code128Name = "Code 128"
private let code39Name = "Code 39"
private let code93Name = "Code 93"
private let UPCName = "UPC"
private let PDF417Name = "PDF417"
private let EAN13Name = "EAN-13"
private let aztecName = "Aztec"
private let ITF14Name = "ITF-14"

public enum OTOBarcodeType {
    /// maps to `AVMetadataObject.ObjectType.qr`
    case QRCode
    /// maps to `AVMetadataObject.ObjectType.dataMatrix`
    case dataMatrix
    /// maps to `AVMetadataObject.ObjectType.code128`
    case code128
    /// maps to `AVMetadataObject.ObjectType.code39`
    case code39
    /// maps to `AVMetadataObject.ObjectType.code93`
    case code93
    /// maps to `AVMetadataObject.ObjectType.upce`
    case UPC
    /// maps to `AVMetadataObject.ObjectType.pdf417`
    case PDF417
    /// maps to `AVMetadataObject.ObjectType.ean13`
    case EAN13
    /// maps to `AVMetadataObject.ObjectType.aztec`
    case aztec
    /// maps to `AVMetadataObject.ObjectType.itf14`
    case ITF14
    /// maps 2 of the above types
    indirect case stacked(OTOBarcodeType, OTOBarcodeType)

    public func code() -> String {
        switch self {
        case .stacked(let first, let second):
            if case OTOBarcodeType.stacked(_, _) = first {
                fatalError("Multiply nested stacked barcode types not supported.")
            }
            if case OTOBarcodeType.stacked(_, _) = second {
                fatalError("Multiply nested stacked barcode types not supported.")
            }
            return "\(first.code())\(stackedRawStringSeparator)\(second.code())"
        case .QRCode: return QRCodeName
        case .dataMatrix: return dataMatrixName
        case .code128: return code128Name
        case .code39: return code39Name
        case .code93: return code93Name
        case .UPC: return UPCName
        case .PDF417: return PDF417Name
        case .EAN13: return EAN13Name
        case .aztec: return aztecName
        case .ITF14: return ITF14Name
        }
    }
}

// MARK: RawRepresentable
extension OTOBarcodeType: RawRepresentable {
    public init?(rawValue: String) {
        if rawValue.contains(where: { (c) -> Bool in
            return c == Character(stackedRawStringSeparator)
        }) {
            let parts = rawValue.components(separatedBy: stackedRawStringSeparator).filter({ (part) -> Bool in
                return !part.isEmpty
            })
            precondition(parts.count == 2, "Stacked barcodes must have exactly two elements in their string representation, separated by '\(stackedRawStringSeparator)'")
            guard let first = OTOBarcodeType(rawValue: parts[0]), let second = OTOBarcodeType(rawValue: parts[1]) else {
                return nil
            }
            self = .stacked(first, second)
        } else {
            switch rawValue {
            case QRCodeName: self = .QRCode
            case dataMatrixName: self = .dataMatrix
            case code128Name: self = .code128
            case code39Name: self = .code39
            case code93Name: self = .code93
            case UPCName: self = .UPC
            case PDF417Name: self = .PDF417
            case EAN13Name: self = .EAN13
            case aztecName: self = .aztec
            case ITF14Name: self = .ITF14
            default: return nil
            }
        }
    }

    /// :nodoc:
    public var rawValue: String {
        return code()
    }
}

// MARK: Init
extension OTOBarcodeType {
    #if swift(>=4)
        init?(metadataType: AVMetadataObject.ObjectType) {
            switch metadataType {
            case AVMetadataObject.ObjectType.qr: self = .QRCode
            case AVMetadataObject.ObjectType.dataMatrix: self = .dataMatrix
            case AVMetadataObject.ObjectType.code128: self = .code128
            case AVMetadataObject.ObjectType.code39: self = .code39
            case AVMetadataObject.ObjectType.code93: self = .code93
            case AVMetadataObject.ObjectType.upce: self = .UPC
            case AVMetadataObject.ObjectType.pdf417: self = .PDF417
            case AVMetadataObject.ObjectType.ean13: self = .EAN13
            case AVMetadataObject.ObjectType.aztec: self = .aztec
            case AVMetadataObject.ObjectType.itf14: self = .ITF14
            default: return nil
            }
        }
    #else
        init?(metadataType: AVMetadataObjectType) {
            if metadataType as String == AVMetadataObjectTypeQRCode { self = .QRCode }
            else if metadataType as String == AVMetadataObjectTypeDataMatrixCode { self = .dataMatrix }
            else if metadataType as String == AVMetadataObjectTypeCode128Code { self = .code128 }
            else if metadataType as String == AVMetadataObjectTypeCode39Code { self = .code39 }
            else if metadataType as String == AVMetadataObjectTypeCode93Code { self = .code93 }
            else if metadataType as String == AVMetadataObjectTypeUPCECode { self = .UPC }
            else if metadataType as String == AVMetadataObjectTypePDF417Code { self = .PDF417 }
            else if metadataType as String == AVMetadataObjectTypeEAN13Code { self = .EAN13 }
            else if metadataType as String == AVMetadataObjectTypeAztecCode { self = .aztec }
            else if metadataType as String == AVMetadataObjectTypeITF14Code { self = .ITF14 }
            else { return nil }
        }
    #endif
}

// MARK: Supported barcodes
extension OTOBarcodeType {
    #if swift(>=4)
        static var supportedBarcodes: [AVMetadataObject.ObjectType] {
            return [
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.dataMatrix,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code93,
                AVMetadataObject.ObjectType.upce,
                AVMetadataObject.ObjectType.pdf417,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.aztec,
                AVMetadataObject.ObjectType.itf14,
            ]
        }
    #else
        static var supportedBarcodes: [AVMetadataObjectType] {
            return [
                AVMetadataObjectTypeQRCode as NSString,
                AVMetadataObjectTypeDataMatrixCode as NSString,
                AVMetadataObjectTypeCode128Code as NSString,
                AVMetadataObjectTypeCode39Code as NSString,
                AVMetadataObjectTypeCode93Code as NSString,
                AVMetadataObjectTypeUPCECode as NSString,
                AVMetadataObjectTypePDF417Code as NSString,
                AVMetadataObjectTypeEAN13Code as NSString,
                AVMetadataObjectTypeAztecCode as NSString,
                AVMetadataObjectTypeITF14Code as NSString,
            ]
        }
    #endif
}
