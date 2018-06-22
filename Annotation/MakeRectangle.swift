//
//  MakeRectangle.swift
//  Annotation
//
//  Created by Kazuyuki Nakatsu on 6/21/18.
//  Copyright © 2018 Kazuyuki Nakatsu. All rights reserved.
//

import Cocoa

class MakeRectangle: NSView {
    
    var start_point: CGPoint?
    var end_point:   CGPoint?
    var shapeLayer : CAShapeLayer!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.red.cgColor
        shapeLayer.lineDashPattern = [10,5]
        self.layer?.addSublayer(shapeLayer)
    }
    override func mouseDown(with event: NSEvent) {

        self.start_point = self.convert(event.locationInWindow, from: nil)
    
    }
    override func mouseUp(with event: NSEvent){
        
        self.end_point = self.convert(event.locationInWindow, from: nil)
        
        let path = CGMutablePath()
        path.move(to: self.start_point!)
        path.addLine(to: NSPoint(x: (self.start_point?.x)!, y: (self.end_point?.y)!))
        path.addLine(to: self.end_point!)
        path.addLine(to: NSPoint(x:(self.end_point?.x)!,y:(self.start_point?.y)!))
        path.closeSubpath()
        self.shapeLayer.path = path
        
        
        // layerから消す
        //self.shapeLayer.removeFromSuperlayer()
        //self.shapeLayer = nil
        
        // ここで他の処理をする
        
        
        
    }
    
    
    
}
