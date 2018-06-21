//
//  ViewController.swift
//  Annotation
//
//  Created by Kazuyuki Nakatsu on 6/15/18.
//  Copyright © 2018 Kazuyuki Nakatsu. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    
    
    // 画像を表示させるimageView
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var imageWell: NSImageView!
    @IBOutlet weak var CustomView: NSView!
    
    
    // メンバ
    var first_point  = CGPoint.zero
    var end_point    = CGPoint.zero
    var text_write:String = "yeah"
    var filename:String   = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dr = NSView()
        dr.frame = NSRect(x: imageWell.frame.minX, y: imageWell.frame.minY, width: imageWell.frame.width, height: imageWell.frame.size.height)
        self.view.addSubview(dr)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        first_point = CGPoint(x: event.locationInWindow.y, y: event.locationInWindow.y)
        print(first_point)
    }
    override func mouseDragged(with event: NSEvent) {
        
        end_point = CGPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)
        print(end_point)
        self.imageWell.image?.draw(in: NSRect(x: first_point.x , y: first_point.y , width: end_point.x - first_point.x, height: end_point.y - first_point.y))
    }
    
    
    
    
    
    func drawRect(){
    
            view = DrawRectangle(frame: NSRect(x: first_point.x , y: first_point.y , width: end_point.x - first_point.x, height: end_point.y - first_point.y))
            CustomView.addSubview(view)
    }
    
    
    // ファイルを一つづつ選択するボタン
    @IBAction func selectFile(_ sender: Any) {
        
        let dialog = NSOpenPanel() //ファイルを開くダイアログ
        dialog.canChooseDirectories=false // ディレクトリを選択できるか
        dialog.canChooseFiles = true // ファイルを選択できるか
        dialog.canCreateDirectories = false // ディレクトリを作成できるか
        dialog.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        dialog.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        dialog.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {// ファイルを選択したか(OKを押したか)
                guard dialog.url != nil else { return }
                //log.info(url.absoluteString)
                //urlのStringを保存
                self.filename = (dialog.url?.absoluteString)!
                // ここでファイルを読み込む
                self.imageWell.image = NSImage(contentsOf: dialog.url!)
            }
        }
    }
    
    @IBAction func Save(_ sender: Any) {
        
        //desktopに書きだし
        if let dir = FileManager.default.urls( for: .desktopDirectory, in: .userDomainMask ).first {
            
            let path_file_name = dir.appendingPathComponent(filename)
            
            do {
                
                try text_write.write( to: path_file_name, atomically: false, encoding: String.Encoding.utf8 )
                
            } catch {
                //エラー処理
            }
        }
        
        
        
        
        
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "\(filename).jpeg"
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                guard let URL = savePanel.url else { return }
                //log.info(url.absoluteString)
                
            }
        }
    
    }
    
    
    
    
    
}
class DrawRectangle: NSView{
    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current?.cgContext
        NSColor.green.set()
        context?.addRect(dirtyRect)
        context?.fillPath()
    }
}
