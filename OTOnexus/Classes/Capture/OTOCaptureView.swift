//
//  CaptuerViewInternal.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/14/17.
//

import UIKit
import AVFoundation

class OTOCaptureView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    fileprivate static let AI_GTIN = "01"
    
    @IBOutlet weak var previewBox: OTOPreviewBox!
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
    
    weak var delegate : OTOCaptureViewDelegate?
    var captureSession:AVCaptureSession?
    var stillCameraOutput: AVCaptureStillImageOutput?
    var videoConnection:AVCaptureConnection?
    var metaDataOutput: AVCaptureMetadataOutput?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    var qrCodeFrameView:UIView?
    var stackedResult : Set<String> = []
    var scanStacked = false {
        didSet {
            if oldValue != scanStacked {
                resetResults()
            }
        }
    }
    let stackedHeightMultiplier: CGFloat = 1.0
    let singleHeightMultiplier: CGFloat = 1.0
    var processing = false
    var strBase64 = String()
    
    #if swift(>=4)
        fileprivate var captureDevice : AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
    #else
        fileprivate var captureDevice : AVCaptureDevice? = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    #endif
    
    enum Status {
        case scanning, stacking, completed
    }
    
    
    var scanStatus = Status.scanning
    var codeDetectionShape = CAShapeLayer()
    
    #if swift(>=4)
        let supportedBarCodes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.itf14]
    #else
        let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeITF14Code]
    #endif
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        codeDetectionShape.strokeColor = UIColor.green.cgColor
        codeDetectionShape.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.25).cgColor
        codeDetectionShape.lineWidth = 2
        captureBarcodes()
    }
    
    
    class func fromNib() -> OTOCaptureView? {
        guard let path = Bundle(for: OTOCaptureView.self).path(forResource: "OTOnexus", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let contentView = bundle.loadNibNamed("OTOCaptureView", owner: nil.self, options: nil)?.first as? OTOCaptureView else {
            return nil
        }
        return contentView
    }
    
    override func didMoveToSuperview() {
        previewBox.addLabel(previewLabel)
        self.bringSubview(toFront: self.previewBox)
        self.bringSubview(toFront: self.previewLabel)
        self.bringSubview(toFront: self.torchButton)
        self.bringSubview(toFront: self.resetButton)
        self.bringSubview(toFront: self.barcodeTypeControl)
        
        self.styleView()
        
        if (!(captureSession?.isRunning ?? false))
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
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        previewBox.setHeightMultiplier(stackedHeightMultiplier)
        videoPreviewLayer.frame = self.layer.bounds
        #if swift(>=4)
            let rectOfInterest : CGRect = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: previewBox.frame)
        #else
            let rectOfInterest : CGRect = videoPreviewLayer.metadataOutputRectOfInterest(for: previewBox.frame)
        #endif
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
        scanStatus = Status.scanning
        self.barcodeTypeControl.selectedSegmentIndex = self.scanStacked ? 0 : 1
    }
    
    func startCaptureIfNotRunning() {
        guard let captureSession = captureSession else { return }
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func toggleFlash() {
        guard let captureDevice = captureDevice else {return}
        if (captureDevice.hasTorch) {
            do {
                if captureDevice.hasTorch {
                    self.torchButton.tintColor = UIColor.blue
                    try captureDevice.lockForConfiguration()
                    #if swift(>=4)
                        if (captureDevice.torchMode == AVCaptureDevice.TorchMode.on) {
                            captureDevice.torchMode = AVCaptureDevice.TorchMode.off
                            self.torchButton.tintColor = UIColor.white
                        } else {
                            do {
                                try captureDevice.setTorchModeOn(level: 1.0)
                            } catch {
                                print(error)
                            }
                        }
                    #else
                        if (captureDevice.torchMode == AVCaptureTorchMode.on) {
                            captureDevice.torchMode = AVCaptureTorchMode.off
                            self.torchButton.tintColor = UIColor.white
                        } else {
                            do {
                                try captureDevice.setTorchModeOnWithLevel(1.0)
                            } catch {
                                print(error)
                            }
                        }
                    #endif
                    
                    captureDevice.unlockForConfiguration()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func processScanned(metadataObjects:[AnyObject]) {
        if (scanStatus != Status.completed) && processing == false && metadataObjects.count > 0 {
            processing = true
            if(scanStacked) {
                processStacked(metadataObjects: metadataObjects)
            } else {
                processSingle(metadataObjects: metadataObjects)
            }
        } else {
            clearBarcodeBounds()
        }
        
        processing =  false
    }
    
    func processStacked(metadataObjects:[AnyObject]) {
        // print("PROCESSING STACKED BARCODE")
        stackedResult.insert(processBarcode(metadataObjects as [AnyObject]))
        if(stackedResult.count == 2) {
            print("STACKED RESULT",stackedResult)
            
            let gtinSegment = stackedResult.first(where: { (res) -> Bool in
                return findGtin(res)
            })
            
            var rawScanData = ""
            if let gtinSegment = gtinSegment {
                stackedResult.remove(gtinSegment)
                if let otherPart = stackedResult.first {
                    rawScanData = gtinSegment + "\u{1D}" + otherPart
                }
            } else {
                rawScanData = stackedResult.joined(separator: "\u{1D}")
            }
            
            print("RawData Unicode", Array(rawScanData.unicodeScalars))
            
            previewBox.setLabelText("2/2 Scanned")
            
            self.finishBarcodeScan(barcode: rawScanData)
        } else if stackedResult.count == 1 {
            scanStatus = Status.stacking
            previewBox.yellow()
            previewBox.setLabelText("1/2 Scanned")
        } else if stackedResult.count > 2 {
            resetResults()
            scanStatus = Status.scanning
        }
    }
    
    func processSingle(metadataObjects:[AnyObject]) {
        print("PROCESSING SINGLE BARCODE")
        let result = processBarcode(metadataObjects as [AnyObject])
        if !result.isEmpty {
            print("RawData Unicode", Array(result.unicodeScalars))
            
            finishBarcodeScan(barcode: result)
        }
        else {
            resetResults()
            scanStatus = Status.scanning
        }
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    // swift 4
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        processScanned(metadataObjects: metadataObjects)
    }

    //swift 3.2
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        let metadataObjects = metadataObjects as [AnyObject]
        processScanned(metadataObjects: metadataObjects)
    }
    
    fileprivate func finishBarcodeScan(barcode:String) {
        scanStatus = Status.completed
        previewBox.green()
        //Take photo of scan to be sent to platform//
        clearBarcodeBounds()
        if (delegate != nil) {
            //Take photo of scan to be sent to platform//
            takePhoto(capturedImage: { (image) in
                self.didCapture(barcode: barcode, image: image)
            })
        }
    }
    
    fileprivate func didCapture(barcode: String, image:UIImage) {
        OTOProduct.search(barcodeData: barcode) { (product, error) in
            if let product = product {
                product.capturedImage = image
                self.delegate?.didCapture(product: product)
            } else if let error = error {
                switch error {
                case .productNotFound:
                    self.delegate?.scannedBarcodeDoesNotExist(barcode: barcode, image: image)
                case .otoError(let otoError):
                    self.delegate?.didEncounterError(error: otoError)
                }
            }
        }
    }
    
    fileprivate func takePhoto(capturedImage:@escaping (UIImage) -> Void) {
        if let stillOutput = stillCameraOutput {
            // we do this on another thread so that we don't hang the UI
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                var videoConnection : AVCaptureConnection?
                
                if let connections = stillOutput.connections as? [AVCaptureConnection] {
                    for connection in connections {
                        //find a matching input port
                        #if swift(>=4)
                            let inputPorts = connection.inputPorts
                        #else
                            let inputPorts = connection.inputPorts as? [AVCaptureInputPort] ?? [AVCaptureInputPort]()
                        #endif
                        for port in inputPorts {
                            #if swift(>=4)
                                if port.mediaType == AVMediaType.video {
                                    videoConnection = connection
                                    break //for port
                                }
                            #else
                                if port.mediaType == AVMediaTypeVideo {
                                    videoConnection = connection
                                    break //for port
                                }
                            #endif
                        }
                        
                        if videoConnection  != nil {
                            break// for connections
                        }
                    }
                }
                
                if let videoConnection = videoConnection {
                    stillOutput.captureStillImageAsynchronously(from: videoConnection) { (imageSampleBuffer: CMSampleBuffer?, err: Error?) -> Void in
                        
                        if let imageSampleBuffer = imageSampleBuffer {
                            if let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer),
                                let pickedImage = UIImage(data: imageDataJpeg) {
                                capturedImage(pickedImage)
                            }
                            // ...
                        } else {
                            // handle or ignore the error
                        }
                    }
                }
            }
        }
    }
}


// MARK: Private functions

extension OTOCaptureView {
    fileprivate func pathForCorners(from barcodeObject: AVMetadataMachineReadableCodeObject,
                                    transformedForLayer previewLayer: AVCaptureVideoPreviewLayer) -> CGPath
    {
        let transformedObject = previewLayer.transformedMetadataObject(for: barcodeObject) as? AVMetadataMachineReadableCodeObject
        
        // new mutable path
        let path = CGMutablePath()
        
        var corners = [CGPoint]()
        
        #if swift(>=4)
            if let objectCorners = transformedObject?.corners {
                corners = objectCorners
            }
        #else
            if let cornerDictionarys = transformedObject?.corners as? [NSDictionary] {
                for corner in cornerDictionarys {
                    if let point = CGPoint(dictionaryRepresentation: corner) {
                        corners.append(point)
                    }
                }
            }
        #endif
        
        for corner in corners {
            path.move(to: corner)
            path.addLine(to: corner)
        }
        
        path.closeSubpath()
        
        return path
    }
    
    fileprivate func findGtin(_ str: String) -> Bool {
        return str.hasPrefix(OTOCaptureView.AI_GTIN)
    }
    
    fileprivate func captureBarcodes() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        guard let captureDevice = self.captureDevice else { return }
        
        do {
            if captureDevice.isSmoothAutoFocusSupported {
                try captureDevice.lockForConfiguration()
                #if swift(>=4)
                    captureDevice.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                #else
                    captureDevice.focusMode = AVCaptureFocusMode.continuousAutoFocus
                #endif
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
            
            #if swift(>=4)
                if(captureDevice.supportsSessionPreset(AVCaptureSession.Preset.hd1920x1080)) {
                    captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                } else {
                    captureSession?.sessionPreset = AVCaptureSession.Preset.medium
                }
                
                videoConnection = self.captureMetadataOutput.connection(with: AVMediaType.video)
            #else
                if(captureDevice.supportsAVCaptureSessionPreset(AVCaptureSessionPreset1920x1080)) {
                    captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
                } else {
                    captureSession?.sessionPreset = AVCaptureSessionPresetMedium
                }
                
                videoConnection = self.captureMetadataOutput.connection(withMediaType: AVMediaTypeVideo)
            #endif
            
            if ((videoConnection?.isVideoStabilizationSupported) != nil){
                videoConnection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                
            }
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            //  let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            #if swift(>=4)
                if let stillCameraOutput = stillCameraOutput {
                    //Add output of camera still of barcode image
                    captureSession?.addOutput(stillCameraOutput)
                }
                if let captureSession = captureSession {
                    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                }
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            #else
                //Add output of camera still of barcode image
                captureSession?.addOutput(stillCameraOutput)

                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            #endif
            if let videoPreviewLayer = videoPreviewLayer {
                videoPreviewLayer.frame = self.layer.bounds
                videoPreviewLayer.borderColor = UIColor.green.cgColor
                self.layer.addSublayer(videoPreviewLayer)
            }
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
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
        if let barcodeObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            supportedBarCodes.contains(barcodeObj.type) && barcodeObj.stringValue != nil {
            drawBarcodeBounds(barcodeObj)
            
            #if swift(>=4)
                return sanitizeBarcodeString(barcodeObj.stringValue ?? "")
            #else
                return sanitizeBarcodeString(barcodeObj.stringValue)
            #endif
        } else {
            return ""
        }
    }
}