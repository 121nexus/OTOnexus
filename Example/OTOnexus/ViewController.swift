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
        self.captureView.scanStacked = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func printModules() {
        guard let session = self.session else { return }
        for module in session.page {
            if let imageUpload = module as? OTOImageUploadModule {
                print(imageUpload)
                // upload image
                //                                        imageUpload.upload(image: product.capturedImage!, complete: { (success, image) in
                //                                            print(image!)
                //                                        })
            } else if let video = module as? OTOVideoModule {
                print(video.videoUrl)
                // Mark video as played
                video.videoPlayed()
            } else if let gudid = module as? OTOGudidModule {
                gudid.lookup(success: { (response) in
                    print(response.deviceDescription)
                }, failure: { (response) in
                    print(response.message)
                })
            } else if let safetyCheck = module as? OTOSafetyCheckModule {
                safetyCheck.checkSafety(success: { (response) in
                    
                })
            } else if let reorder = module as? OTOReorderModule {
                print("amount to be reordered \(reorder.orderQuatity)")
                reorder.reorder(success: { (quantity) in
                    print("reordered \(quantity)")
                })
            } else if let gs1 = module as? OTOGs1ValidationModule {
                gs1.validateBarcode(complete: { (validationResponse) in
                    print(validationResponse.allErrorMessages)
                })
            }
        }
    }
}

extension ViewController : CaptureViewDelegate {
    public func scannedBarcodeDoesNotExist(barcode: String) {
        Session.startSession(withExperienceId: 1, barcode: barcode) { (session) in
            self.session = session
            self.printModules()
        }
    }
    
    public func didCapture(product: Product) {
        guard let defaultExperience = product.defaultExperience else { return }
        Session.startSession(withExperience: defaultExperience,
                             product: product) { (session) in
                                self.session = session
                                self.printModules()
        }
    }
}

