//
//  ViewController.swift
//  MultipleImagePicker
//
//  Created by tatsumi kentaro on 2018/02/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase


class ViewController: UIViewController,UIImagePickerControllerDelegate {
    var selectImages: UIImage!
    var imageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func taped(_ sender: Any) {
        
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = {(assets: [DKAsset]) in
//            self.uid = Auth.auth().currentUser?.uid
            let storage = Storage.storage()
            //ストレージ接続
            let ref = storage.reference()
             //時間を取得
            let date = NSDate()
            //時間を文字列に整形
            let format = DateFormatter()
            // 選択された画像はassetsに入れて返却されますのでfetchして取り出すと
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    self.selectImages = image
                     format.dateFormat = "yyyy_MM_dd_HH_mm_ss_\(self.imageNumber)"
                     let datePath = format.string(from: date as Date)
                    self.imageNumber += 1
                    //画像をjpgのデータ形式に変換
                    let imageData: Data = UIImageJPEGRepresentation(self.selectImages, 0.1)!
                    let imagePath = ref.child("image").child("tatsumi").child("\(datePath).jpg")
                    let uploadTask = imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            print("アップロード失敗")
                            // Uh-oh, an error occurred!
                            return
                        }
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata.downloadURL
                        print(downloadURL)
                    }
                    print("これが\(image!)")
                })
            }
//            self.dismiss(animated: true, completion: nil)
        }
        present(pickerController, animated: true, completion: nil)
    }
    
    
}

