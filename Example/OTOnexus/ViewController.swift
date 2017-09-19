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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureView.delegate = self
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 10.0)], for: .normal)
    }

    @IBAction func resetAction(_ sender: Any) {
        self.captureView.resetResults()
    }
    
    @IBAction func flashAction(_ sender: Any) {
        self.captureView.toggleFlash()
    }
    
    @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
        self.captureView.scanStacked = sender.selectedSegmentIndex == 0
    }
}

extension UIViewController : CaptureViewDelegate {
    public func didCapture(product: Product) {
        guard let defaultExperience = product.defaultExperience else { return }
        Session.startSession(withExperience: defaultExperience,
                             product: product) { (session) in
                                print(session.id)
        }
    }
}

