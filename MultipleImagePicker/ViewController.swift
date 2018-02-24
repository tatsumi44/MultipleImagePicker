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
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    var imageArray = [UIImage]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    @IBAction func taped(_ sender: Any) {
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 3
        pickerController.didSelectAssets = {(assets: [DKAsset]) in

            // 選択された画像はassetsに入れて返却されますのでfetchして取り出すと
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
//                    self.selectImages = image
                    self.imageArray.append(image!)
                    
                    
                    print("これが\(String(describing: type(of: image!)))")
                })
                print(self.imageArray)
                
                print("ええで")
            }
            self.image1.image = self.imageArray[0]
            self.image2.image = self.imageArray[1]
            self.image3.image = self.imageArray[2]
//            self.dismiss(animated: true, completion: nil)
        }
        present(pickerController, animated: true, completion: nil)
        if imageArray.isEmpty == false{
           
           
        }else{
            print("b")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
    }
    
    @IBAction func send(_ sender: Any) {
        let storage = Storage.storage()
        //ストレージ接続
        let ref = storage.reference()
        //時間を取得
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        for image in imageArray{
            format.dateFormat = "yyyy_MM_dd_HH_mm_ss_\(self.imageNumber)"
            let datePath = format.string(from: date as Date)
            self.imageNumber += 1
            //画像をjpgのデータ形式に変換
            selectImages = image
            let imageData: Data = UIImageJPEGRepresentation(selectImages, 0.1)!
            let imagePath = ref.child("image").child("test").child("\(datePath).jpg")
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
            
        }
        
    }
    
}

