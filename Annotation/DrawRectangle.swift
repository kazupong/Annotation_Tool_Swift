//
//  DrawRectangle.swift
//  Annotation
//
//  Created by Kazuyuki Nakatsu on 6/21/18.
//  Copyright © 2018 Kazuyuki Nakatsu. All rights reserved.
//

import Cocoa
import QuartzCore


class DrawRectangle: NSView {
    
    
    
    var start_point: CGPoint?
    var end_point:   CGPoint?
    var shapeLayer : CAShapeLayer!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func mouseDown(with event: NSEvent) {
        print("mouseDown: \(event.locationInWindow)")
        //start_point = event.locationInWindow
        
        self.start_point = self.convert(event.locationInWindow, from: nil)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.lineDashPattern = [10,5]
        self.layer?.addSublayer(shapeLayer)
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        shapeLayer.add(dashAnimation, forKey: "linePhase")
    }
    
    override func mouseDragged(with event: NSEvent) {
        print("mouseDragged\(event.locationInWindow)")
        
        let point : NSPoint = self.convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        path.move(to: self.start_point!)
        path.addLine(to: NSPoint(x: (self.start_point?.x)!, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x,y:(self.start_point?.y)!))
        path.closeSubpath()
        self.shapeLayer.path = path
        
    }
    
    override func mouseUp(with event: NSEvent){
        print("mouseUP: \(event.locationInWindow)")
        end_point = event.locationInWindow
        
        
        // layerから消す
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
        
       /*
        let path = CGMutablePath()
        //path.
        path.move(to: self.start_point!)
        path.addLine(to: NSPoint(x: (self.start_point?.x)!, y: (end_point?.y)!))
        path.addLine(to: end_point!)
        path.addLine(to: NSPoint(x:(end_point?.x)!,y:(self.start_point?.y)!))
        path.closeSubpath()
        
        var newShape = CAShapeLayer()
        newShape.path = path
        newShape.lineWidth = 3.0
        newShape.strokeColor = NSColor.blue.cgColor
        newShape.fillColor = NSColor.blue.cgColor
        self.shapeLayer.path = path
        self.shapeLayer.addSublayer(newShape)
        */
        
        
        
        
        
    }
}
