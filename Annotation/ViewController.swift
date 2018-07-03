//
//  ViewController.swift
//  Annotation
//
//  Created by Kazuyuki Nakatsu on 6/15/18.
//  Copyright © 2018 Kazuyuki Nakatsu. All rights reserved.
//
//  http://www.extelligentcocoa.org/nsopenpanel-nssavepanel/
//

import Cocoa
import QuartzCore

class ViewController: NSViewController,NSTableViewDataSource {
    
    /* Outlet */
    @IBOutlet var mainView: NSView!
    @IBOutlet weak var imageView:  NSImageView!
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var topCustomView: NSView!
    @IBOutlet weak var displayTextView: NSTextField!
    
    /* メンバ */
    var image:NSImage?
    let windowTitle: String? = "EZ Label"
    var filename:String   = ""
    var folderName:String = ""
    
    // imagefileのPATHを保存する
    var fileImageUrl:[URL] = []
    // 許可するイメージファイルの種類
    let extentions = ["jpg","png","tif"]
    
    
    var demo_array = [[1,1,1,1],[2,2,2,2],[3,3,3,3]]
    
    //@IBOutlet var rectArray: NSArrayController!
    var rectArray: Array<NSRect> = Array()
    
    /* Application life circle */
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // displayTextView.text = "file not selected"
        
        self.view.wantsLayer = true
       
    }
    
    override func viewWillAppear() {
        
        //mainView.window?.titleVisibility = .hidden
        mainView.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        //mainView.window?.backgroundColor = NSColor.darkGray
        mainView.window?.title = windowTitle!
        
        //mainView.layer?.backgroundColor = NSColor.black.cgColor
        mainView.layer?.setNeedsDisplay()
        
        topCustomView.layer?.backgroundColor = NSColor.gray.cgColor
        topCustomView.layer?.setNeedsDisplay()
        
        customView.layer?.backgroundColor = NSColor.shadowColor.cgColor
        customView.layer?.setNeedsDisplay()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    /* 描写した矩形を全て消すボタンのアクション */
    @IBAction func deleteAllButton(_ sender: Any) {
        while (self.customView.layer?.sublayers?.capacity)! > 1 {
            self.customView.layer?.sublayers?.popLast()
        }
        // tableViewに表示した矩形の情報も削除する
        // code here!
        //
    }
    /*直前に描写した矩形を消すボタンのアクション*/
    @IBAction func deleteButton(_ sender: Any) {
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
        
        /* ここで次の画像やテーブル情報を更新する処理*/
        if fileImageUrl.count > 1 {
            // stack implement if needed ----------------------------------------------------------debug later as needed
            fileImageUrl.removeFirst()
            self.imageView.image = NSImage(contentsOf: fileImageUrl[0])
            self.image = NSImage(contentsOf: fileImageUrl[0])
        }
        else{
            
            self.imageView.image = #imageLiteral(resourceName: "image_last")
        }
        
        
        
        
        
        
    }
    
    /* select file ボタンが押される際のアクション：画像ファイルをFinderからひとつ手動で選択し、表示させるボタン */
    @IBAction func selectFileButton(_ sender: Any) {
        
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
                
                // filenameをwindowに表示させる
                self.displayTextView.stringValue = self.filename
                
                // ここでファイルを読み込む
                self.imageView.image = NSImage(contentsOf: dialog.url!)
                self.image = NSImage(contentsOf: dialog.url!)
            }
        }
    } // ----------
    
    /* selectFolderボタンが押された際のアクション*/
    @IBAction func selectFolderButton(_ sender: Any) {
        
        let dialog = NSOpenPanel() //ファイルを開くダイアログ
        dialog.canChooseDirectories = true // ディレクトリを選択できるか
        dialog.canChooseFiles = false // ファイルを選択できるか
        dialog.canCreateDirectories = false // ディレクトリを作成できるか
        dialog.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        dialog.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        dialog.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {// ファイルを選択したか(OKを押したか)
                guard dialog.url != nil else { return }
                
                //urlのStringを保存
                self.folderName = (dialog.url?.absoluteString)!
                
                // ここでfolderから画像ファイルの"---ファイル名のみ---"読み込みlistに保存
                let enumerator = FileManager.default.enumerator(at: (dialog.url)!, includingPropertiesForKeys: nil)
                
                while let element = enumerator?.nextObject() as? URL{
                    
                    do{
                        let url:String = String(element.pathExtension)
                        if self.extentions.contains(url){
                              self.fileImageUrl.append(element)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
                // filenameをwindowに表示させる
                self.displayTextView.stringValue = self.fileImageUrl[0].absoluteString
                
                /* 画像イメージに切り替え */
                self.imageView.image = NSImage(contentsOf: self.fileImageUrl[0])
                self.image = NSImage(contentsOf: self.fileImageUrl[0])
            }
        }
        
    } // -------------
    
    
    
    

}
// ------------------  the end of ViewController.swift  -----------------
