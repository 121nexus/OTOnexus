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
    @IBOutlet weak var captureView: OTOCaptureView!
    public var session:OTOSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureView.delegate = self
        self.captureView.scanStacked = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handle(error:OTOError) {
        switch error {
        case .errorFromServer(let error):
            print(error)
        case .errorWithMessage(let message):
            print(message)
        case .unauthenticated:
            print("Please provide valid API Key")
        }
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
                gudid.lookup(complete: { (response, error) in
                    if let response = response as? OTOLookupSuccessResponse {
                        print(response.deviceDescription)
                        if let lot = response.lot {
                            print(lot)
                        }
                        if let expirationDate = response.expirationDate {
                            // swift Date type
                            print(expirationDate)
                        }
                    } else if let response = response as? OTOLookupFailureResponse {
                        print(response.message)
                    } else if let error = error {
                        self.handle(error: error)
                    }
                })
            } else if let safetyCheck = module as? OTOSafetyCheckModule {
                safetyCheck.checkSafety(complete: { (response, error) in
                    if let error = error {
                        self.handle(error: error)
                    }
                })
            } else if let reorder = module as? OTOReorderModule {
                print("amount to be reordered \(reorder.orderQuatity)")
                reorder.reorder(complete: { (quantity, error) in
                    if let quantity = quantity {
                        print("reordered \(quantity)")
                    } else if let error = error {
                        self.handle(error: error)
                    }
                })
            } else if let gs1 = module as? OTOGs1ValidationModule {
                gs1.validateBarcode(complete: { (validationResponse, error) in
                    if let validationResponse = validationResponse {
                        print(validationResponse.allErrorMessages)
                    } else if let error = error {
                        self.handle(error: error)
                    }
                })
            }
        }
    }
}

extension ViewController : OTOCaptureViewDelegate {
    public func scannedBarcodeDoesNotExist(barcode: String) {
        OTOSession.startSession(withExperienceId: 4, barcode: barcode) { (session, error) in
            if let session = session {
                self.session = session
                self.printModules()
            } else if let error = error {
                self.handle(error: error)
            }
        }
    }
    
    public func didCapture(product: OTOProduct) {
        guard let defaultExperience = product.defaultExperience else { return }
        OTOSession.startSession(withExperience: defaultExperience,
                             product: product) { (session, error) in
                                if let session = session {
                                    self.session = session
                                    self.printModules()
                                } else if let error = error {
                                    self.handle(error: error)
                                }
        }
    }
    
    func didEncounterError(error: OTOError) {
        handle(error: error)
    }
}

