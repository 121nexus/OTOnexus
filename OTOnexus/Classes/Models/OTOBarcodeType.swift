//
//  OTOBarcodeType.swift
//  OTOnexus
//
//  Created by Andrew McKnight on 2/8/18.
//

import AVFoundation
import Foundation

public enum OTOBarcodeType: String {
    case code_128_Concatenated = "Code 128 concatenated"
    case code_128_Stacked = "Code 128 stacked"
    case dataMatrix = "DataMatrix"
    case EAN_UPC = "EAN/UPC"
    case ITF‌_14 = "_ITF-14_"
    case GS1_Databar = "GS1 Databar"
    case QR_Code = "QR Code"
}

// MARK: Init
extension OTOBarcodeType {
    #if swift(>=4)
        init?(metadataType: AVMetadataObject.ObjectType) {
            switch metadataType {
            case AVMetadataObject.ObjectType.qr: self = .QR_Code
            case AVMetadataObject.ObjectType.dataMatrix: self = .dataMatrix
            case AVMetadataObject.ObjectType.code128: self = .code_128_Concatenated
            case AVMetadataObject.ObjectType.code39: return nil
            case AVMetadataObject.ObjectType.code93: return nil
            case AVMetadataObject.ObjectType.upce: return nil
            case AVMetadataObject.ObjectType.pdf417: return nil
            case AVMetadataObject.ObjectType.ean13: return nil
            case AVMetadataObject.ObjectType.aztec: return nil
            case AVMetadataObject.ObjectType.itf14: self = .ITF‌_14
            default: return nil
            }
        }
    #else
        init?(metadataType: AVMetadataObjectType) {
            if metadataType as String == AVMetadataObjectTypeQRCode { self = .QR_Code }
            else if metadataType as String == AVMetadataObjectTypeDataMatrixCode { self = .dataMatrix }
            else if metadataType as String == AVMetadataObjectTypeCode128Code { self = .code_128_Concatenated }
            else if metadataType as String == AVMetadataObjectTypeCode39Code { return nil }
            else if metadataType as String == AVMetadataObjectTypeCode93Code { return nil }
            else if metadataType as String == AVMetadataObjectTypeUPCECode { return nil }
            else if metadataType as String == AVMetadataObjectTypePDF417Code { return nil }
            else if metadataType as String == AVMetadataObjectTypeEAN13Code { return nil }
            else if metadataType as String == AVMetadataObjectTypeAztecCode { return nil }
            else if metadataType as String == AVMetadataObjectTypeITF14Code { self = .ITF‌_14 }
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
