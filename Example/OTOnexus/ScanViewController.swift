//
//  ScanViewController.swift
//  OTOnexus_Example
//
//  Created by Christopher DeOrio on 11/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import OTOnexus

class ScanViewController: UIViewController, OTOCaptureViewDelegate {
    @IBOutlet weak var captureView: OTOCaptureView!
    var session:OTOSession?
    var barcodeString = ""
    var autocaptureImage = UIImage()
    var videoUrl: String = ""
    var videoType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureView.delegate = self
        self.captureView.scanStacked = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.captureView.resetResults()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToExperience(session:OTOSession) {
            self.session = session
            self.performSegue(withIdentifier: "toExperience", sender: self)
    }
    
    
    func handle(error:OTOError) {
        switch error {
        case .connectivityError(let error, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(error)
        case .validationErrorWithMessage(let message, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(message)
        case .serverErrorWithMessage(let message, let httpUrlResponse):
            if let httpUrlResponse = httpUrlResponse {
                print(httpUrlResponse.statusCode)
            }
            print(message)
        case .unauthenticated:
            print("Please provide valid API Key")
        }
    }

    func scannedBarcodeDoesNotExist(barcode: String) {
        OTOSession.startSession(withExperienceId: 8, barcode: barcode) { (session, error) in
            if let session = session {
                print("Session Page", session.page)
                self.barcodeString = barcode
                self.session = session
                self.goToExperience(session: session)
            } else if let error = error {
                self.handle(error: error)
            }
        }
    }

    func didCapture(product: OTOProduct) {
        guard let defaultExperience = product.defaultExperience else { return }
        OTOSession.startSession(withExperience: defaultExperience,
                                product: product) { (session, error) in
                                    if let session = session {
                                        print("Session Page", session.page)
                                        self.barcodeString = product.barcodeData!
                                        self.session = session
                                        self.goToExperience(session: session)
                                    } else if let error = error {
                                        self.handle(error: error)
                                    }
        }
    }
    
    func didEncounterError(error: OTOError) {
        handle(error: error)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toExperience" {
            let nextViewController = (segue.destination as! ExperienceViewController)
            nextViewController.currentSession = self.session
            nextViewController.barcodeRawScanData = barcodeString
        }
    }

}



