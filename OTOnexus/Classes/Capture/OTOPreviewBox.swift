//
//  OTOPreviewBox.swift
//  OTOnexus
//
//  Copyright © 2016 121nexus. All rights reserved.
//

import UIKit
import CoreGraphics

class OTOPreviewBox: UIView {
    
    var color: UIColor = UIColor.red
    let EDGE_LENGTH: CGFloat = 20.0
    var multiplier: CGFloat = 1.0
    let lineWidth: CGFloat = 3
    let crosshairLineWidth: CGFloat = 1
    let crosshairSize: CGFloat = 30.0
    let crosshairVerticalOffset: CGFloat = 0.0
    var previewLabel: UILabel = UILabel()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        
        // Drawing code
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        color.setStroke()

        let height = self.bounds.height/multiplier
        let yOffset = self.bounds.minY + (self.bounds.height - height) / 2.0
        let bounds = CGRect(x: self.bounds.minX, y: yOffset, width: self.bounds.width, height: height)
        let box: CGRect = bounds.insetBy(dx: lineWidth/2.0, dy: lineWidth/2.0)
        
        ctx.setLineWidth(lineWidth)
        
        let minX: CGFloat = box.minX
        let minY: CGFloat = box.minY
        
        let maxX: CGFloat = box.maxX
        let maxY: CGFloat = box.maxY
        
        // top left
        ctx.move(to: CGPoint(x: minX, y: minY + EDGE_LENGTH))
        ctx.addLine(to: CGPoint(x: minX, y: minY))
        ctx.addLine(to: CGPoint(x: minX +  EDGE_LENGTH, y: minY))
        
        // bottom left
        ctx.move(to: CGPoint(x: minX, y: maxY - EDGE_LENGTH))
        ctx.addLine(to: CGPoint(x: minX, y: maxY))
        ctx.addLine(to: CGPoint(x: minX +  EDGE_LENGTH, y: maxY))
        
        // top right
        ctx.move(to: CGPoint(x: maxX - EDGE_LENGTH, y: minY))
        ctx.addLine(to: CGPoint(x: maxX, y: minY))
        ctx.addLine(to: CGPoint(x: maxX, y: minY +  EDGE_LENGTH))
        
        // bottom right
        ctx.move(to: CGPoint(x: maxX - EDGE_LENGTH, y: maxY))
        ctx.addLine(to: CGPoint(x: maxX, y: maxY))
        ctx.addLine(to: CGPoint(x: maxX, y: maxY - EDGE_LENGTH))
        
        ctx.strokePath()
        
        ctx.setLineWidth(crosshairLineWidth)
        
        // cross horizontal
        ctx.move(to: CGPoint(x: (maxX - crosshairSize)/2.0, y: maxY/2.0 + crosshairVerticalOffset))
        ctx.addLine(to: CGPoint(x: (maxX + crosshairSize)/2.0, y: maxY/2.0  + crosshairVerticalOffset))
        
        //cross vertical
        ctx.move(to: CGPoint(x: maxX/2.0, y: (maxY - crosshairSize)/2.0  + crosshairVerticalOffset))
        ctx.addLine(to: CGPoint(x: maxX/2.0, y: (maxY + crosshairSize)/2.0  + crosshairVerticalOffset))
        
        ctx.strokePath()
    }
    
    public func red() {
        color = UIColor.red
        previewLabel.textColor = color
        self.setNeedsDisplay()
    }
    
    public func yellow() {
        color = UIColor.yellow
        previewLabel.textColor = color
        self.setNeedsDisplay()
    }
    
    public func green() {
        color = UIColor.green
        previewLabel.textColor = color
        self.setNeedsDisplay()
    }

    public func setHeightMultiplier(_ mult: CGFloat) {
        multiplier = mult
        self.setNeedsDisplay()
    }
    
    public func setLabelText(_ str: String) {
        previewLabel.text = str
    }
    
    public func addLabel(_ label: UILabel) {
        previewLabel = label
    }
}
