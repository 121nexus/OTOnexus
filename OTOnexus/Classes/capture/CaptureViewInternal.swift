//
//  CaptuerViewInternal.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/14/17.
//

import UIKit
import AVFoundation

protocol CaptureViewInternalDelegate: class {
    func didCapture(barcode: String, image:UIImage)
    func connectionLost()->Bool
}


//@objc protocol MDTCaptureViewControllerDelegate
//{
//    @objc optional func previewController(_ previewController: MDTValidationViewController, didScanCode code: NSString, ofType type: NSString)
//}


class CaptureViewInternal: UIView, AVCaptureMetadataOutputObjectsDelegate {
    fileprivate static let AI_GTIN = "01"
    
    @IBOutlet public weak var previewBox: OTOPreviewBox!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var previewBoxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var barcodeTypeControl: UISegmentedControl!
    
    private var areAnyTopButtonsVisible:Bool {
        return !isTorchHidden || !isResetHidden
    }
    
    var isTorchHidden = false {
        didSet {
            if oldValue != isTorchHidden {
                self.previewBoxTopConstraint.constant = areAnyTopButtonsVisible ? 76 : 16
                self.torchButton.isHidden = isTorchHidden
                self.layoutIfNeeded()
            }
        }
    }
    var isResetHidden = false {
        didSet {
            if oldValue != isResetHidden {
                self.previewBoxTopConstraint.constant = areAnyTopButtonsVisible ? 76 : 16
                self.resetButton.isHidden = isResetHidden
                self.layoutIfNeeded()
            }
        }
    }
    var isBarcodeTypeHidden = false {
        didSet {
            if oldValue != isBarcodeTypeHidden {
                self.previewBoxBottomConstraint.constant = !isBarcodeTypeHidden ? 65 : 16
                self.barcodeTypeControl.isHidden = isBarcodeTypeHidden
                self.layoutIfNeeded()
            }
        }
    }
    
    var delegate : CaptureViewInternalDelegate?
    var captureSession:AVCaptureSession?
    var stillCameraOutput: AVCaptureStillImageOutput?
    var videoConnection:AVCaptureConnection?
    var metaDataOutput: AVCaptureMetadataOutput?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    var qrCodeFrameView:UIView?
    var sessionKey = ""
    var possibleGTINs : [String] = []
    let listOfCodes: NSMutableSet = []
    var latitudeString = ""
    var longitudeString = ""
    var statusCode: Int = Int()
    var rawScanData = String()
    var result = String()
    var stackedResult : Set<String> = []
    var GTIN = String()
    public var scanStacked = false {
        didSet {
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }
    let stackedHeightMultiplier: CGFloat = 1.0
    let singleHeightMultiplier: CGFloat = 1.0
    var processing = false
    var barcodeStringToPass = String()
    var pickedImage: UIImage = UIImage()
    var strBase64 = String()
    
    fileprivate var captureDevice : AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    enum Status {
        case scanning, stacking, completed
    }
    
    
    var scanStatus = Status.scanning
    var codeDetectionShape = CAShapeLayer()
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeITF14Code]
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)

        codeDetectionShape.strokeColor = UIColor.green.cgColor
        codeDetectionShape.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.25).cgColor
        codeDetectionShape.lineWidth = 2
        captureBarcodes()
    }
    
    override public func didMoveToSuperview() {
        previewBox.addLabel(previewLabel)
        self.bringSubview(toFront: self.previewBox)
        self.bringSubview(toFront: self.previewLabel)
        self.bringSubview(toFront: self.torchButton)
        self.bringSubview(toFront: self.resetButton)
        self.bringSubview(toFront: self.barcodeTypeControl)
        
        self.styleView()
        
        //print("testing life cycle")
        if (!(captureSession?.isRunning)!)
        {
            print("Capture Session is not running yet");
            return
        }
    }
    
    private func styleView() {
        self.torchButton.layer.cornerRadius = 5
        self.torchButton.layer.masksToBounds = true
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewBox.setHeightMultiplier(stackedHeightMultiplier)
        self.videoPreviewLayer?.frame = self.layer.bounds
        let rectOfInterest : CGRect = videoPreviewLayer!.metadataOutputRectOfInterest(for: previewBox.frame)
        metaDataOutput?.rectOfInterest = rectOfInterest
    }
    
    @IBAction func resetAction(_ sender: Any) {
        self.resetResults()
    }
    
    @IBAction func flashAction(_ sender: Any) {
        self.toggleFlash()
    }
    
    @IBAction func switchBarcodeTypeAction(_ sender: Any) {
        self.scanStacked = self.barcodeTypeControl.selectedSegmentIndex == 0
    }
    
    func resetResults() {
        if scanStacked {
            previewBox.setLabelText("0/2 Scanned")
        } else {
            previewBox.setLabelText("")
        }
        //spinner.stopAnimating()
        previewBox.red()
        stackedResult = []
        result = ""
        GTIN = ""
        rawScanData = ""
        barcodeStringToPass = ""
        scanStatus = Status.scanning
        self.barcodeTypeControl.selectedSegmentIndex = self.scanStacked ? 0 : 1
    }
    
    func toggleFlash() {
        if (self.captureDevice.hasTorch) {
            do {
                if self.captureDevice.hasTorch {
                    self.torchButton.tintColor = UIColor.blue
                    try self.captureDevice.lockForConfiguration()
                    if (self.captureDevice.torchMode == AVCaptureTorchMode.on) {
                        self.captureDevice.torchMode = AVCaptureTorchMode.off
                        self.torchButton.tintColor = UIColor.white
                    } else {
                        do {
                            try self.captureDevice.setTorchModeOnWithLevel(1.0)
                        } catch {
                            print(error)
                        }
                    }
                    
                    self.captureDevice.unlockForConfiguration()
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        if (scanStatus != Status.completed) && processing == false && metadataObjects != nil && metadataObjects.count > 0 {
            processing = true
            if(scanStacked) {
                // print("PROCESSING STACKED BARCODE")
                stackedResult.insert(processBarcode(metadataObjects as [AnyObject]))
                if(stackedResult.count == 2) {
                    print("STACKED RESULT",stackedResult)
                    var gtin_segment = ""
                    for res in stackedResult {
                        if !findGtin(res).isEmpty {
                            GTIN = findGtin(res)
                            gtin_segment = res
                        }
                    }
                    if gtin_segment.isEmpty {
                        
                        rawScanData = stackedResult.joined(separator: "\u{1D}")
                    } else {
                        rawScanData = stackedResult.remove(gtin_segment)! + "\u{1D}" + stackedResult.first!
                    }
                    print("RawData Unicode", Array(rawScanData.unicodeScalars))
                    
                    barcodeStringToPass = rawScanData
                    print("Barcode String to pass", barcodeStringToPass)
                    
                    previewBox.setLabelText("2/2 Scanned")
                    
                    self.finishBarcodeScan()
                } else if stackedResult.count == 1 {
                    scanStatus = Status.stacking
                    previewBox.yellow()
                    previewBox.setLabelText("1/2 Scanned")
                } else if stackedResult.count > 2 {
                    resetResults()
                    scanStatus = Status.scanning
                    
                }
            } else {
                print("PROCESSING SINGLE BARCODE")
                result = processBarcode(metadataObjects as [AnyObject])
                if !result.isEmpty {
                    GTIN = findGtin(result)
                    rawScanData = result
                    print("RawData Unicode", Array(rawScanData.unicodeScalars))
                    
                    barcodeStringToPass = rawScanData
                    print("Barcode String to pass", barcodeStringToPass)
                    finishBarcodeScan()
                }
                else {
                    resetResults()
                    scanStatus = Status.scanning
                }
            }
        }
        else
        {
            clearBarcodeBounds()
        }
        
        processing =  false
        return
        
    }
    
    fileprivate func finishBarcodeScan() {
        scanStatus = Status.completed
        previewBox.green()
        //Take photo of scan to be sent to platform//
        clearBarcodeBounds()
        if (delegate != nil) {
            if (delegate?.connectionLost())! {
                ///No connection
                self.resetResults()
                scanStatus = Status.scanning
            } else {
                //Take photo of scan to be sent to platform//
                takePhoto(capturedImage: { (image) in
                    self.delegate?.didCapture(barcode: self.barcodeStringToPass, image: image)
                })
                
            }
        }
    }
    
    fileprivate func takePhoto(capturedImage:@escaping (UIImage) -> Void) {
        if let stillOutput = stillCameraOutput {
            // we do this on another thread so that we don't hang the UI
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                //find the video connection
                var videoConnection : AVCaptureConnection?
                for connecton in stillOutput.connections {
                    //find a matching input port
                    for port in (connecton as AnyObject).inputPorts!{
                        if (port as AnyObject).mediaType == AVMediaTypeVideo {
                            videoConnection = connecton as? AVCaptureConnection
                            break //for port
                        }
                    }
                    
                    if videoConnection  != nil {
                        break// for connections
                    }
                }
                if videoConnection  != nil {
                    
                    stillOutput.captureStillImageAsynchronously(from: videoConnection) { (imageSampleBuffer: CMSampleBuffer?, err: Error?) -> Void in
                        
                        if imageSampleBuffer != nil {
                            let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                            self.pickedImage = UIImage(data: imageDataJpeg!)!
                            self.strBase64 = (imageDataJpeg?.base64EncodedString(options: .lineLength64Characters))!
                            // ...
                        } else {
                            // handle or ignore the error
                        }
                        
                        capturedImage(self.pickedImage)
                    }
                }
            }
        }
    }
}


// MARK: Private functions

extension CaptureViewInternal {
    fileprivate func pathForCorners(from barcodeObject: AVMetadataMachineReadableCodeObject,
                                    transformedForLayer previewLayer: AVCaptureVideoPreviewLayer) -> CGPath
    {
        let transformedObject = previewLayer.transformedMetadataObject(for: barcodeObject) as? AVMetadataMachineReadableCodeObject
        
        // new mutable path
        let path = CGMutablePath()
        
        for corner in transformedObject!.corners as! [NSDictionary] {
            let point = CGPoint(dictionaryRepresentation: corner)!
            path.move(to: point)
            path.addLine(to: point)
        }
        
        path.closeSubpath()
        
        return path
    }
    
    fileprivate func findGtin(_ str: String) -> String! {
        if str.hasPrefix(CaptureViewInternal.AI_GTIN) {
            return String(String(str.characters.dropFirst(2)).characters.prefix(14))
        } else {
            return ""
        }
    }
    
    fileprivate func captureBarcodes() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            if captureDevice.isSmoothAutoFocusSupported {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = AVCaptureFocusMode.continuousAutoFocus
                captureDevice.unlockForConfiguration()
            }
            ////TODO: Play around with capture quality to get best results for low light in warehouse
            
        } catch {
            print(error)
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            //Initialize AVCaptureStillIamgeOutput
            stillCameraOutput = AVCaptureStillImageOutput()
            
            
            if(captureDevice.supportsAVCaptureSessionPreset(AVCaptureSessionPreset1920x1080)) {
                captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
                
            } else {
                captureSession?.sessionPreset = AVCaptureSessionPresetMedium
            }
            
            
            videoConnection = self.captureMetadataOutput.connection(withMediaType: AVMediaTypeVideo)
            if ((videoConnection?.isVideoStabilizationSupported) != nil){
                videoConnection!.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                
            }
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            //  let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //Add output of camera still of barcode image
            captureSession?.addOutput(stillCameraOutput)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = self.layer.bounds
            videoPreviewLayer?.borderColor = UIColor.green.cgColor
            self.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                self.addSubview(qrCodeFrameView)
                self.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    fileprivate func drawBarcodeBounds(_ code: AVMetadataMachineReadableCodeObject) {
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        if(codeDetectionShape.superlayer == nil) {
            videoPreviewLayer.addSublayer(codeDetectionShape)
        }
        
        //create a suitable CGPath for the barcode area
        let path = pathForCorners(from: code, transformedForLayer: videoPreviewLayer)
        codeDetectionShape.frame = videoPreviewLayer.bounds
        codeDetectionShape.path = path
    }
    
    fileprivate func clearBarcodeBounds() {
        if(codeDetectionShape.superlayer != nil) {
            codeDetectionShape.removeFromSuperlayer()
        }
    }
    
    fileprivate func sanitizeBarcodeString(_ str: String) -> String {
        return str.trimmingCharacters(in: CharacterSet.urlQueryAllowed.inverted)
    }
    
    
    fileprivate func processBarcode(_ metadataObjects: [AnyObject]) -> String {
        let barcodeObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedBarCodes.contains(barcodeObj.type) && barcodeObj.stringValue != nil {
            drawBarcodeBounds(barcodeObj)
            //print("Barcode", barcodeObj.observationInfo.debugDescription)
            
            //            print ("Barcode", barcodeObj.valueForKeyPath("_internal.basicDescriptor")!["BarcodeRawData"])
            
            return sanitizeBarcodeString(barcodeObj.stringValue)
        } else {
            return ""
        }
    }
}
