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
    
    // マウスをドラッグされた時の座標値を保存する変数
    var start_point: CGPoint?
    var end_point:   CGPoint?
    // shapeLayerオブジェクトを宣言
    var shapeLayer : CAShapeLayer!
    // 矩形の色付けするためのクラス変数
    var count4color:Int = 1
    // 矩形の色付けする色の数
    let numColor = 6
    // ViewController Class を呼び出す
    let VC = ViewController()
    
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.darkGray.set()
        super.draw(dirtyRect)
    }
    
    /*マウスのクリックがされた時のアクション*/
    override func mouseDown(with event: NSEvent) {
        
        self.start_point = self.convert(event.locationInWindow, from: nil)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.5
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.purple.cgColor
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
    /* マウスのドラッグされた時のアクション*/
    override func mouseDragged(with event: NSEvent) {
        
        let point : NSPoint = self.convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        path.move(to: self.start_point!)
        path.addLine(to: NSPoint(x: (self.start_point?.x)!, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x,y:(self.start_point?.y)!))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    /* マウスのクリックがあがった時のアクション */
    override func mouseUp(with event: NSEvent){
        //座標の取得
        end_point = event.locationInWindow
        
        // 破線をアニメーションをlayerから消す
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
        //ここで破線の矩形の座標を参考に、新しく矩形を作る
        drawRect()
        
        // 矩形の座標値を渡す
        // debug here!! 
        //
        let temp:NSRect = NSRect(x:   (start_point?.x)!,
                                 y:   (start_point?.y)!,
                                 width:   ((end_point?.x)! - (start_point?.x)!),
                                 height:   ((end_point?.y)! - (start_point?.y)!))
        
        VC.rectArray.append(temp)
        print(VC.rectArray)
    }
    
    // 新しく矩形を作り、色分けしたものを表示
    func drawRect() -> Void {
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = {()-> CGColor in
            
            let colorVal = count4color % numColor
            var returnVal:CGColor?
            
            switch colorVal{
                case 0:
                    returnVal = NSColor.red.cgColor
                case 1:
                    returnVal = NSColor.blue.cgColor
                case 2:
                    returnVal = NSColor.green.cgColor
                case 3:
                    returnVal = NSColor.yellow.cgColor
                case 4:
                    returnVal = NSColor.brown.cgColor
                case 5:
                    returnVal = NSColor.orange.cgColor
                default:
                    print("error in drawRect() from DrawRectangle.swift class")
            }
           
            self.count4color += 1
            
            return returnVal!
        }()
        
        self.layer?.addSublayer(shapeLayer)
        let point : NSPoint = self.convert(end_point!, from: nil)
        let path = CGMutablePath()
        path.move(to: self.start_point!)
        path.addLine(to: NSPoint(x: (self.start_point?.x)!, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x,y:(self.start_point?.y)!))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    func pickColor(int:Int)-> CGColor {
        
        var returnVal:CGColor?
        
        if isIntValid(int: int){
            
            switch int{
            case 0:
                returnVal = NSColor.red.cgColor
            case 1:
                returnVal = NSColor.blue.cgColor
            case 2:
                returnVal = NSColor.green.cgColor
            case 3:
                returnVal = NSColor.yellow.cgColor
            case 4:
                returnVal = NSColor.purple.cgColor
            default:
                print("error in drawRect() from DrawRectangle.swift class")
            }
            self.count4color += 1
            return returnVal!
        }
        print("error in drawRect() from DrawRectangle.swift class")
        return NSColor.darkGray.cgColor
    }
    func isIntValid(int:Int)->Bool{
        if 0 <= int && int <= 5 {
            return true
        }
        return false
    }
    
    
    
}
