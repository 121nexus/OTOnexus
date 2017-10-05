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
    public var session:Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController : CaptureViewDelegate {
    public func scannedBarcodeDoesNotExist(barcode: String) {
        print(barcode)
    }
    
    public func didCapture(product: Product) {
        guard let defaultExperience = product.defaultExperience else { return }
        Session.startSession(withExperience: defaultExperience,
                             product: product) { (session) in
                                self.session = session
                                for module in session.page {
                                    if let imageUpload = module as? OTOImageUploadModule {
                                        print(imageUpload)
                                        // upload image
//                                        imageUpload.upload(image: #imageLiteral(resourceName: "IMG_6636.JPG"), complete: { (success, image) in
//                                            print(image!)
//                                        })
                                    } else if let video = module as? OTOVideoModule {
                                        print(video.videoUrl)
                                        // Mark video as played
//                                        video.videoPlayed()
                                    }
                                }
        }
    }
}

