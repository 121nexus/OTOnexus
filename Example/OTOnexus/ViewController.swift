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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController : CaptureViewDelegate {
    public func didCapture(product: Product) {
        guard let defaultExperience = product.defaultExperience else { return }
        Session.startSession(withExperience: defaultExperience,
                             product: product) { (session) in
                                if let submitAction = session.page.first?.submitAction {
                                    submitAction.perform {
                                        
                                    }
                                }
        }
    }
}

