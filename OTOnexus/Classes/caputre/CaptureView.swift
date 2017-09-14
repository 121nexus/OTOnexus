//
//  CaptureView.swift
//  MDT-Scan-App-V2
//
//  Created by Christopher DeOrio on 2/2/17.
//  Copyright © 2017 Christopher DeOrio. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import JavaScriptCore


public protocol CaptureViewDelegate: class {
    
    func sendRawScanDataString(_ barcodeStringToPass: String)
    func sendScannedImageData(_ pickedImage: UIImage)
    func connectionLost()->Bool
    
    
}


//@objc protocol MDTCaptureViewControllerDelegate
//{
//    @objc optional func previewController(_ previewController: MDTValidationViewController, didScanCode code: NSString, ofType type: NSString)
//}

let AI_GTIN = "01"


public class CaptureView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var myCaptureView: UIView!
    @IBOutlet public weak var previewBox: MDTPreviewBox!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewBoxAspect: NSLayoutConstraint!

    public var delegate : CaptureViewDelegate?
    
    public var captureSession:AVCaptureSession?
    var stillCameraOutput: AVCaptureStillImageOutput?
    var videoConnection:AVCaptureConnection?
    var metaDataOutput: AVCaptureMetadataOutput?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    var qrCodeFrameView:UIView?
    var sessionKey = ""
    var possibleGTINs : [String] = []
    let listOfCodes: NSMutableSet = []
//  let locationManager = CLLocationManager()
    var latitudeString = ""
    var longitudeString = ""
    var statusCode: Int = Int()
    var rawScanData = String()
    var result = String()
    var stackedResult : Set<String> = []
    var GTIN = String()
    public var scanStacked = true
    let stackedHeightMultiplier: CGFloat = 1.0
    let singleHeightMultiplier: CGFloat = 1.0
    var processing = false
    var barcodeStringToPass = String()
    var pickedImage: UIImage = UIImage()
    var strBase64 = String()
    
    public var captureDevice : AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
 
    
    public enum Status {
        case scanning, stacking, completed
    }
    
    
    public var scanStatus = Status.scanning
    var codeDetectionShape = CAShapeLayer()
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeITF14Code]

    required public init?(coder aDecoder:NSCoder) {
        
        super.init(coder: aDecoder)
        

        guard
            let path = Bundle(for: CaptureView.self).path(forResource: "OTOnexus", ofType: "bundle"),
            let bundle = Bundle(path: path)
        else {
            fatalError("No bundle found")
        }
        bundle.loadNibNamed("CaptureView", owner: self, options: nil)
        
        self.addSubview(self.myCaptureView!)
        self.addSubview(self.previewBox)
        previewBox.addLabel(previewLabel)

        codeDetectionShape.strokeColor = UIColor.green.cgColor
        codeDetectionShape.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.25).cgColor
        codeDetectionShape.lineWidth = 2
        captureBarcodes()

    }
    
    override public func didMoveToSuperview() {
        previewBox.addLabel(previewLabel)
        self.bringSubview(toFront: previewBox)
        self.bringSubview(toFront: previewLabel)

        //print("testing life cycle")
        if (!(captureSession?.isRunning)!)
        {
            print("Capture Session is not running yet");
            return
        }
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        previewBox.setHeightMultiplier(stackedHeightMultiplier)
        self.videoPreviewLayer?.frame = self.layer.bounds
        let rectOfInterest : CGRect = videoPreviewLayer!.metadataOutputRectOfInterest(for: previewBox.frame)
        metaDataOutput?.rectOfInterest = rectOfInterest
    }
    
    
    func findGtin(_ str: String) -> String! {
        if str.hasPrefix(AI_GTIN) {
            return String(String(str.characters.dropFirst(2)).characters.prefix(14))
        } else {
            return ""
        }
    }
    
    func captureBarcodes() {
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
    func drawBarcodeBounds(_ code: AVMetadataMachineReadableCodeObject) {
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        if(codeDetectionShape.superlayer == nil) {
            videoPreviewLayer.addSublayer(codeDetectionShape)
        }
        
        //create a suitable CGPath for the barcode area
        let path = pathForCorners(from: code, transformedForLayer: videoPreviewLayer)
        codeDetectionShape.frame = videoPreviewLayer.bounds
        codeDetectionShape.path = path
    }
    
    func clearBarcodeBounds() {
        if(codeDetectionShape.superlayer != nil) {
            codeDetectionShape.removeFromSuperlayer()
        }
    }
    
    func sanitizeBarcodeString(_ str: String) -> String {
        return str.trimmingCharacters(in: CharacterSet.urlQueryAllowed.inverted)
    }

    
    func processBarcode(_ metadataObjects: [AnyObject]) -> String {
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
    
    
    public func resetResults() {
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

    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
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
                    
                    scanStatus = Status.completed
                    previewBox.green()
                    previewBox.setLabelText("2/2 Scanned")
                    
                    //Take photo of scan to be sent to platform//
                    clearBarcodeBounds()
                    if (delegate != nil) {
                        if (delegate?.connectionLost())! {
                        ///No connection
                            self.resetResults()
                            scanStatus = Status.scanning
                        } else {
                            //Take photo of scan to be sent to platform//
                            takePhoto()
                            delegate!.sendRawScanDataString(barcodeStringToPass)
                            
                        }
                    
                        
                    }
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
                    
                    scanStatus = Status.completed
                    previewBox.green()
                    
                    barcodeStringToPass = rawScanData
                    clearBarcodeBounds()
                    print("Barcode String to pass", barcodeStringToPass)
                    if (delegate != nil) {
                        if (delegate?.connectionLost())! {
                            ///No connection
                            self.resetResults()
                            scanStatus = Status.scanning
                        } else {
                            //Take photo of scan to be sent to platform//
                            takePhoto()
                            delegate!.sendRawScanDataString(barcodeStringToPass)
                            
                        }
                        
                        
                    }
                    
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
    
    func takePhoto(){
        
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
                        
                        if (self.delegate != nil) {
                            self.delegate!.sendScannedImageData(self.pickedImage)
                        }
                    }
                }
            }
        }
    }
}


// MARK: Private functions

extension CaptureView {
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
}

