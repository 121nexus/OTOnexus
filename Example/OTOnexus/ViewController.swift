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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

