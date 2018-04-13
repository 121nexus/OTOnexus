//
//  CaptureViewController.swift
//  OTOnexus
//
//  Copyright © 2018 121nexus. All rights reserved.
//

import UIKit

public protocol OTOCaptureViewDelegate: class {
    
    /**
     Delegate method that returns the results of a scanned barcode.
     - Parameters:
        - product: the product mapped to the recognized barcode
     */
    func didCapture(product: OTOProduct)
    
    /**
     Delegate method that returns when a scanned barcode does not exist on the *121nexus Platform*
     - Parameters:
         - barcode: structured information about the scanned barcode
     */
    func scannedBarcodeDoesNotExist(barcode: OTOBarcode)

    /**
     Called if the scanning subsystem detects and capture the barcode, but fails to parse the data inside it. One example is when the barcode data contains two FNC sequences as a prefix: in that case, AVFoundation returns an empty string.
     - Parameter barcode: returned struct containing the autocaptured image of the problem barcode.
     */
    func barcodeParseError(barcode: OTOBarcode)

    /**
     Delegate method called if some other error occurred, e.g. networking or authentication.
     - Parameter error: description of the error
     */
    func didEncounterError(error: OTOError)
    
    func captureViewDidEndNetworkActivity()
    
    func captureViewDidStartNetworkActivity()
}

/**
 OTOCaptureViewController is the UI component that you add to your app to enable 121nexus scanning functionality.
 */
public class OTOCaptureViewController: UIViewController {

    var captureView:OTOCaptureView?
    
    
    /// Sets default barcode type to be scanned to *stacked* vs. *single*
    public var scanStacked = false {
        didSet {
            captureView?.scanStacked = scanStacked
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }
    
    /// Sets up capture view controller and adds the scanner as a subview of the `containerView`
    public class func setup(containerView:UIView,
                            containerController:UIViewController,
                            delegate:OTOCaptureViewDelegate) -> OTOCaptureViewController {
        let captureViewController = OTOCaptureViewController()
        captureViewController.setupCaptureView()
        captureViewController.captureView?.delegate = delegate
        containerController.addChildViewController(captureViewController)
        captureViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(captureViewController.view)
        captureViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        captureViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        captureViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        captureViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        captureViewController.didMove(toParentViewController: containerController)
        
        return captureViewController
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureView?.startCaptureIfNotRunning()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureView?.stopCapture()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleForgrounding), name: .UIApplicationDidBecomeActive, object: nil)
    }
}

// Proxy Functions
extension OTOCaptureViewController {
    /// Change where capture functions are called
    public weak var delegate:OTOCaptureViewDelegate? {
        set {
            captureView?.delegate = delegate
        }
        get {
            return captureView?.delegate
        }
    }

    /// Bool value to hide/show flashlight button
    public var isTorchHidden:Bool {
        set {
            self.captureView?.isTorchHidden = newValue
        }
        get {
            return self.captureView?.isTorchHidden ?? false
        }
    }
    /// Bool value to hide/show scan reset button
    public var isResetHidden:Bool {
        set {
            self.captureView?.isResetHidden = newValue
        }
        get {
            return self.captureView?.isResetHidden ?? false
        }
    }
    /// Bool value to turn hide/show barcode type segmented control
    public var isBarcodeTypeHidden:Bool {
        set {
            self.captureView?.isBarcodeTypeHidden = newValue
        }
        get {
            return self.captureView?.isBarcodeTypeHidden ?? false
        }
    }
    
    /// Resets capture scan view
    public func resetResults() {
        self.captureView?.resetResults()
    }
    /// Turns flashlight on/off
    public func toggleFlash() {
        self.captureView?.toggleFlash()
    }
}

extension OTOCaptureViewController {
    @objc func handleForgrounding() {
        if view.window != nil {
            captureView?.startCaptureIfNotRunning()
        }
    }
}

extension OTOCaptureViewController {
    func setupCaptureView() {
        if let captureView = OTOCaptureView.fromNib() {
            captureView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(captureView)
            self.captureView = captureView
            captureView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            captureView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            captureView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            captureView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

