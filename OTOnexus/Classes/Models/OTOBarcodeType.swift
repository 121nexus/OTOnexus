//
//  OTOBarcodeType.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import AVFoundation
import Foundation

public enum OTOBarcodeType {
    case QRCode
    case dataMatrix
    case code128
    case code39
    case code93
    case UPC
    case PDF417
    case EAN13
    case aztec
    case ITF14
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
            return "\(first.code()),\(second.code())"
        case .QRCode: return "QR Code"
        case .dataMatrix: return "DataMatrix"
        case .code128: return "Code 128"
        case .code39: return "Code 39"
        case .code93: return "Code 93"
        case .UPC: return "UPC"
        case .PDF417: return "PDF417"
        case .EAN13: return "EAN-13"
        case .aztec: return "Aztec"
        case .ITF14: return "ITF-14"
        }
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
