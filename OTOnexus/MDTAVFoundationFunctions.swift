//
//  MDTAVFoundationFunctions.swift
//  swiftMDTScanner
//
//  Created by Christopher DeOrio on 9/27/16.
//  Copyright © 2016 Christopher DeOrio. All rights reserved.
//

import AVFoundation
import UIKit


func MDTAVCaptureVideoOrientationForUIInterfaceOrientation(_ interfaceOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation
{
    switch (interfaceOrientation)
    {
    case .landscapeLeft:
        return .landscapeLeft;
    case .landscapeRight:
        return .landscapeRight;
    case .portrait:
        return .portrait;
    case .portraitUpsideDown:
        return .portraitUpsideDown;
    case .unknown:
        return .portrait
    }
}



func MDTAVMetadataMachineReadableCodeObjectCreatePathForCorners(
    _ previewLayer: AVCaptureVideoPreviewLayer,
    barcodeObject: AVMetadataMachineReadableCodeObject) -> CGPath
{
    let transformedObject: AVMetadataMachineReadableCodeObject? = previewLayer.transformedMetadataObject(for: barcodeObject) as? AVMetadataMachineReadableCodeObject
    
    // new mutable path
    let path: CGMutablePath = CGMutablePath()
    
    var point: CGPoint = CGPoint.zero
    
    //first point
    point = CGPoint(dictionaryRepresentation: transformedObject!.corners[0] as! NSDictionary)!
    path.move(to: point)
    path.addLine(to: point)
    
    //second point
    point = CGPoint(dictionaryRepresentation: transformedObject!.corners[1] as! NSDictionary)!
    path.addLine(to: point)
    
    //third point
    point = CGPoint(dictionaryRepresentation: transformedObject!.corners[2] as! NSDictionary)!
    path.addLine(to: point)
    
    //fourth point
    point = CGPoint(dictionaryRepresentation: transformedObject!.corners[3] as! NSDictionary)!
    path.addLine(to: point)
    
    
    // and back to first point
    path.closeSubpath()
    
    return path
}
