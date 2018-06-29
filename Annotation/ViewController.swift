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
    
    /* 画像を表示させるimageView */
    @IBOutlet weak var imageView:  NSImageView!
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var sidemenuView: NSView!
    @IBOutlet weak var CustomBoxRight: NSBox!
    
    
    /* メンバ */
    var image:NSImage?
    var text_write:String = "yeah"
    var filename:String   = ""
    var demo_array = [[1,1,1,1],[2,2,2,2],[3,3,3,3]]
    
    //@IBOutlet var rectArray: NSArrayController!
    var rectArray: Array<NSRect> = Array()
    
    /* Application life circle */
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override func viewWillAppear() {
        CustomBoxRight.layer?.backgroundColor = NSColor.lightGray.cgColor
        sidemenuView.layer?.backgroundColor = NSColor.lightGray.cgColor
        customView.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        CustomBoxRight.layer?.setNeedsDisplay()
        sidemenuView.layer?.setNeedsDisplay()
        customView.layer?.setNeedsDisplay()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
     /* 指定した矩形を全部消すボタンのアクション　*/
    @IBAction func DeleteALL(_ sender: Any) {
        
        while (self.customView.layer?.sublayers?.capacity)! > 1 {
            self.customView.layer?.sublayers?.popLast()
        }
        
        // tableViewに表示した矩形の情報も削除する
        // code here!
        //
        
    }
     /*直前に描写した矩形を消すボタンのアクション*/
    @IBAction func DeletePrevious(_ sender: Any) {
        
        if (self.customView.layer?.sublayers?.capacity)! > 1 {
            self.customView.layer?.sublayers?.popLast()
        }
        
        // tableViewに表示した矩形の情報も削除する
        // code here!
        //
        
    }
    
    /* Nextボタンが押された時のアクション*/
    @IBAction func NextButton(_ sender: Any) {
        // Note: sandbox in entitlement file has changed to false, meaning that sandbox was disabled,
        //       and this app wont be able to be distributed throuhgout itunes with this status
        
        // writeのPATH設定: Desktopにtxt fileを作成する as fileName below
        let fileName = "annotation_txt_output"
        let DocumentDirURL = try! FileManager.default.url(for: .desktopDirectory,in: .userDomainMask,
                                                          appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("file path \(fileURL.path)")
        
        // ここでdemo_arrayから座標値を取得しStringにpurseして、writeString変数に格納
        var writeString = ""
        while demo_array.isEmpty == false {
            let temp = demo_array.popLast()
            var num = 0
            for ele in temp! {
                writeString += String(ele)
                num += 1
                if temp?.count != num {
                    writeString += ","
                }
            }
            writeString += " "
            num = 0
        }
        // desktopにある（もしくは、存在していなければ自動で新規に作成される）txt_output.txtに　writeStringの内容を書き込む
        do {
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError{
            print(error)
        }
        writeString += "\n"
    }
    
    /* 「select file」 ボタンが押される際のアクション：画像ファイルをFinderからひとつ手動で選択し、表示させるボタン */
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
                self.image = NSImage(contentsOf: dialog.url!)
            }
        }
    }
    
    /*Saveボタンが押された際のアクション */
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

