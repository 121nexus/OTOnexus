//
//  ExperienceViewController.swift
//  OTOnexus_Example
//
//  Created by Christopher DeOrio on 11/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import OTOnexus
import AVFoundation
import AVKit

class ExperienceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageModule: UIView!
    @IBOutlet weak var footerModule: UIView!
    @IBOutlet weak var textModule: UIView!
    @IBOutlet weak var rawBarcodeStringModule: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var takePhotoLabel: UILabel!
    @IBOutlet weak var returnedImage: UIImageView!
    @IBOutlet weak var imageModuleView: UIView!
    @IBOutlet weak var imageActivity: UIActivityIndicatorView!
    @IBOutlet weak var rawBarcodeLabel: UITextView!
    @IBOutlet weak var textModuleLabel: UILabel!
    
    let picker = UIImagePickerController ()
    var currentSession : OTOSession?
    var barcodeRawScanData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Camera picker
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType =  UIImagePickerControllerSourceType.camera
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        
        currentSession?.delegate = self
        // Do any additional setup after loading the view.
        self.rawBarcodeLabel.text = barcodeRawScanData
      
        matchViewsToModules(firstLoad:true)
        self.textModuleLabel.text = currentSession?.textModule?.content
        fakeSurvey()
    }
    
    func fakeSurvey() {
        guard let survey = currentSession?.surveyModule else {
            return
        }
        for question in survey.questions {
            if let select = question as? OTOSurveySelectQuestion {
                select.selection = select.answers.first
            } else if let text = question as? OTOSurveyTextQuestion {
                text.response = "A Response"
            } else if let date = question as? OTOSurveyDateQuestion {
                date.date = Date()
            }
        }
        survey.submitSurvey { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function matches the views created to the modules returned from the experience.
    func matchViewsToModules(firstLoad:Bool) {
        for stackView in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(stackView)
            imageModule.isHidden = true
            self.viewDidLayoutSubviews()
        }
        guard let currentSession = self.currentSession else { return }
        
        //Find modules in current session and add it to the stackView
        for module in currentSession.page {
            if module is OTOImageUploadModule {
                self.stackView.addArrangedSubview(self.imageModule)
            }
            if module is OTOTextModule {
                self.stackView.addArrangedSubview(self.textModule)
            }
        }
        self.stackView.insertArrangedSubview(self.rawBarcodeStringModule, at: 0)
        self.stackView.addArrangedSubview(self.footerModule)
        
    }
    
    // MARK: - imageUpload Module interactions. Tapping the camera button will present a camera picker to take a photo that will be uploaded to the platform.
    @IBAction func takePicture(_ sender: Any) {
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        let uploadModule = currentSession?.imageUpload
        self.imageActivity.startAnimating()
        uploadModule?.upload(image: chosenImage, complete: { (image, error) in
            print(error != nil ? "No" : "Yes!")
            self.returnedImage.image = image
            self.imageActivity.stopAnimating()
        })
        self.imageModuleView.isHidden = true
        self.returnedImage.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}


extension ExperienceViewController: OTOSessionDelegate {
    func sessionDidUpdatePage() {
        currentSession?.preloadModuleData { (success, errors) in
            if success {
                print("Loaded next page", self.currentSession?.page as Any)
                self.matchViewsToModules(firstLoad:false)
            }
            else {
                print(errors)
            }
        }
    }
}

extension OTOSession {
    
    func moduleOfType<T>() -> T? {
        return page.first(where: { (module) -> Bool in
            return module is T
        }) as? T
    }
    
    var imageUpload:OTOImageUploadModule? {
        get {
            return moduleOfType()
        }
    }
    
    var gs1ValidationModule:OTOGs1ValidationModule? {
        get {
            return moduleOfType()
        }
    }
    
    var surveyModule:OTOSurveyModule? {
        get {
            return moduleOfType()
        }
    }
    
    var textModule:OTOTextModule? {
        get {
            return moduleOfType()
        }
    }
}
