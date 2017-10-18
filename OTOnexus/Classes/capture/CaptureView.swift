//
//  CaptureView.swift
//  MDT-Scan-App-V2
//
//  Created by Christopher DeOrio on 2/2/17.
//  Copyright © 2017 Christopher DeOrio. All rights reserved.
//

import UIKit
import Foundation

public protocol OTOCaptureViewDelegate: class {
    
    func didCapture(product:OTOProduct)
    func scannedBarcodeDoesNotExist(barcode:String)
    
}

public class OTOCaptureView: UIView {
    var captureViewInternal:CaptureViewInternal?

    public weak var delegate : OTOCaptureViewDelegate?
    public var scanStacked = false {
        didSet {
            captureViewInternal?.scanStacked = scanStacked
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }
    
    public var isTorchHidden:Bool {
        set {
            self.captureViewInternal?.isTorchHidden = newValue
        }
        get {
            return self.captureViewInternal?.isTorchHidden ?? false
        }
    }
    public var isResetHidden:Bool {
        set {
            self.captureViewInternal?.isResetHidden = newValue
        }
        get {
            return self.captureViewInternal?.isResetHidden ?? false
        }
    }
    public var isBarcodeTypeHidden:Bool {
        set {
            self.captureViewInternal?.isBarcodeTypeHidden = newValue
        }
        get {
            return self.captureViewInternal?.isBarcodeTypeHidden ?? false
        }
    }

    required public init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)

        guard
            let path = Bundle(for: CaptureViewInternal.self).path(forResource: "OTOnexus", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let captureViewInternal = bundle.loadNibNamed("CaptureViewInternal", owner: self, options: nil)?.first as? CaptureViewInternal
        else {
            fatalError("No bundle found")
        }
        self.captureViewInternal = captureViewInternal
        captureViewInternal.translatesAutoresizingMaskIntoConstraints = false
        captureViewInternal.delegate = self
        self.addSubview(captureViewInternal)
        captureViewInternal.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        captureViewInternal.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        captureViewInternal.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        captureViewInternal.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    public func resetResults() {
        self.captureViewInternal?.resetResults()
    }
    
    public func toggleFlash() {
        self.captureViewInternal?.toggleFlash()
    }
}

extension OTOCaptureView : CaptureViewInternalDelegate {
    func didCapture(barcode: String, image:UIImage) {
        OTOProduct.search(barcodeData: barcode,
                       success: { (product) in
                        product.capturedImage = image
                        self.delegate?.didCapture(product: product)
        },
                       failure: { (error) in
                        switch error {
                        case .productNotFound:
                            self.delegate?.scannedBarcodeDoesNotExist(barcode: barcode)
                        default:
                            break
                        }
                        
        })
    }
    
    func connectionLost() -> Bool {
        return false
    }
}


