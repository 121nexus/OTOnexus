//
//  ViewController.swift
//  OTOnexus
//
//  Created by Nic Schlueter on 09/08/2017.
//  Copyright (c) 2017 121nexus. All rights reserved.
//

import UIKit
import OTOnexus

class ViewController: UIViewController {
    @IBOutlet weak var captureView: CaptureView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureView.delegate = self
    }

    @IBAction func resetAction(_ sender: Any) {
        captureView.resetResults()
    }
    
    @IBAction func flashAction(_ sender: Any) {
        captureView.toggleFlash()
    }
    
    @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
      captureView.scanStacked = sender.selectedSegmentIndex == 0
    }
}

extension UIViewController : CaptureViewDelegate {
    public func sendRawScanDataString(_ barcodeStringToPass: String) {
        
    }
    
    public func sendScannedImageData(_ pickedImage: UIImage) {
        
    }
    
    public func connectionLost() -> Bool {
        return false
    }
}

