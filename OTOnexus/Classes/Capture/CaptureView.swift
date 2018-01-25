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
    
    /// Delegate method that returns the results of a scanned barcode and takes a parameter of a *product*
    func didCapture(product:OTOProduct)
    
    /// Delegate method that returns when a scanned barcode does not exist on the *121nexus Platform*
    func scannedBarcodeDoesNotExist(barcode:String, image:UIImage)
    
    func didEncounterError(error: OTOError)
    
}
/**
 OTOCaptureView is a class that provides scanning functionality to capture barcodes and provide the data associated with them. Through its delegate methods it returns the raw barcode string that can be used to search on the *121nexus platform*
 */
public class OTOCaptureView: UIView {
    var captureViewInternal:CaptureViewInternal?
    
    /// Main delegate that has two methods associated with it *didCapture(product:OTOProduct)* and *scannedBarcodeDoesNotExist(barcode:String)*
    public weak var delegate : OTOCaptureViewDelegate?
    
    /// Sets default barcode type to be scanned to *stacked* vs. *single*
    public var scanStacked = false {
        didSet {
            captureViewInternal?.scanStacked = scanStacked
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }
    /// Bool value to hide/show flashlight button
    public var isTorchHidden:Bool {
        set {
            self.captureViewInternal?.isTorchHidden = newValue
        }
        get {
            return self.captureViewInternal?.isTorchHidden ?? false
        }
    }
    /// Bool value to hide/show scan reset button
    public var isResetHidden:Bool {
        set {
            self.captureViewInternal?.isResetHidden = newValue
        }
        get {
            return self.captureViewInternal?.isResetHidden ?? false
        }
    }
    /// Bool value to turn hide/show barcode type segmented control
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
    /// Resets capture scan view
    public func resetResults() {
        self.captureViewInternal?.resetResults()
    }
    /// Turns flashlight on/off
    public func toggleFlash() {
        self.captureViewInternal?.toggleFlash()
    }
}

extension OTOCaptureView : CaptureViewInternalDelegate {
    func didCapture(barcode: String, image:UIImage) {
        OTOProduct.search(barcodeData: barcode) { (product, error) in
            if let product = product {
                product.capturedImage = image
                self.delegate?.didCapture(product: product)
            } else if let error = error {
                switch error {
                case .productNotFound:
                    self.delegate?.scannedBarcodeDoesNotExist(barcode: barcode, image: image)
                case .otoError(let otoError):
                    self.delegate?.didEncounterError(error: otoError)
                }
            }
        }
    }
    
    func connectionLost() -> Bool {
        return false
    }
}


