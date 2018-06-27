//
//  ViewController.swift
//  Annotation
//
//  Created by Kazuyuki Nakatsu on 6/15/18.
//  Copyright © 2018 Kazuyuki Nakatsu. All rights reserved.
//

import Cocoa
import QuartzCore

class ViewController: NSViewController,NSTableViewDataSource {
    
    // 画像を表示させるimageView
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var customView02: NSView!
    
    // メンバ
    var text_write:String = "yeah"
    var filename:String   = ""
    
    //@IBOutlet var rectArray: NSArrayController!
    var rectArray: Array<NSRect> = Array()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // 破線の矩形をマウス操作で表示
        let dr = DrawRectangle(frame: customView.frame)
        self.customView.addSubview(dr)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rectArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return rectArray[row]
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
                self.imageView.image = NSImage(contentsOf: dialog.url!)
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
