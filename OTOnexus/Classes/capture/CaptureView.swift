//
//  CaptureView.swift
//  MDT-Scan-App-V2
//
//  Created by Christopher DeOrio on 2/2/17.
//  Copyright © 2017 Christopher DeOrio. All rights reserved.
//

import UIKit
import Foundation

public protocol CaptureViewDelegate: class {
    
    func didCapture(product:Product)
    
}

public class CaptureView: UIView {
    var captureViewInternal:CaptureViewInternal?

    public weak var delegate : CaptureViewDelegate?
    public var scanStacked = true {
        didSet {
            captureViewInternal?.scanStacked = scanStacked
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }

    required public init?(coder aDecoder:NSCoder) {
        
        super.init(coder: aDecoder)

        guard
            let path = Bundle(for: CaptureViewInternal.self).path(forResource: "OTOnexus", ofType: "bundle"),
            let bundle = Bundle(path: path)
        else {
            fatalError("No bundle found")
        }
        captureViewInternal = bundle.loadNibNamed("CaptureViewInternal", owner: self, options: nil)!.first! as! CaptureViewInternal
        captureViewInternal?.translatesAutoresizingMaskIntoConstraints = false
        captureViewInternal?.delegate = self
        self.addSubview(captureViewInternal!)
        captureViewInternal?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        captureViewInternal?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        captureViewInternal?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        captureViewInternal?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    public func resetResults() {
        self.captureViewInternal?.resetResults()
    }
    
    public func toggleFlash() {
        self.captureViewInternal?.toggleFlash()
    }
}

extension CaptureView : CaptureViewInternalDelegate {
    public func sendRawScanDataString(_ barcodeStringToPass: String) {
        Product.search(barcodeData: barcodeStringToPass) { (product) in
            self.delegate?.didCapture(product: product)
        }
    }
    
    public func sendScannedImageData(_ pickedImage: UIImage) {
        
    }
    
    public func connectionLost() -> Bool {
        return false
    }
}


