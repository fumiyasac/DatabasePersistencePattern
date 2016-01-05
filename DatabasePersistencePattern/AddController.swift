//
//  AddController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import RealmSwift

class AddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Outlet接続したもの
    @IBOutlet weak var selectedDbText: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var omiyageImageView: UIImageView!
    
    //変数＆定数
    var selectedDb: Int!
    
    var omiyageTitle: String!
    var omiyageDetail: String!
    var omiyageImage: UIImage!
    var currentDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        self.omiyageImageView.contentMode = UIViewContentMode.ScaleToFill
        self.omiyageImage = UIImage(named: "noimage_omiyage_comment.jpg")
        self.omiyageImageView.image = self.omiyageImage
        self.selectedDbText.text = "選択したデータベース：Realm"
        
        //UITextFieldのデリゲート設定
        self.titleTextField.delegate = self
        self.detailTextField.delegate = self
        
        self.titleTextField.placeholder = "(例）タイトルが入ります"
        self.detailTextField.placeholder = "(例）商品紹介が入ります"
        
    }
    
    //ボタンアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func omiyageImageAction(sender: UIButton) {
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "おみやげの写真を記録する",
            message: "写真付きのおみやげリストを記録しましょう(^^)",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "ライブラリから選択",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "カメラで撮影",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.Cancel,
                handler: handlerActionSheet
            )
        )
        presentViewController(alertActionSheet, animated: true, completion: nil)
        
    }
    
    //アクションシートの結果に応じて処理を変更
    func handlerActionSheet(ac: UIAlertAction) -> Void {
        
        switch ac.title! {
            case "ライブラリから選択":
                self.selectAndDisplayFromPhotoLibrary()
                break
            case "カメラで撮影":
                self.loadAndDisplayFromCamera()
                break
            case "キャンセル":
                break
            default:
                break
        }
    }
    
    //ライブラリから写真を選択してimageに書き出す
    func selectAndDisplayFromPhotoLibrary() {
        
        //フォトアルバムを表示
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    //カメラで撮影してimageに書き出す
    func loadAndDisplayFromCamera() {
        
        //カメラを起動
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(ip, animated: true, completion: nil)
    }
    
    //画像を選択した時のイベント
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //画像をセットして戻る
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //リサイズして表示する
        let resizedImage = CGRectMake(
            image.size.width / 4.0,
            image.size.height / 4.0,
            image.size.width / 2.0,
            image.size.height / 2.0
        )
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, resizedImage)
        self.omiyageImageView.image = UIImage(CGImage: cgImage!)
    }
    
    @IBAction func addOmiyageDataAction(sender: UIButton) {
        
        //UIImageデータを取得する
        self.omiyageImage = self.omiyageImageView.image
        
        //バリデーションを通す前の準備
        self.omiyageTitle = self.titleTextField.text
        self.omiyageDetail = self.detailTextField.text
        self.currentDate = NSDate()
        
        //Error:UIAlertControllerでエラーメッセージ表示
        if (self.omiyageTitle.isEmpty || self.omiyageDetail.isEmpty) {
            
            //エラーのアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "エラー",
                message: "入力必須の項目に不備があります。",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
            
        //OK:データを1件セーブする
        } else {
            
            
            //Realmにデータを1件登録する
            let omiyageObject = Omiyage.create()
            omiyageObject.title = self.omiyageTitle
            omiyageObject.detail = self.omiyageDetail
            omiyageObject.image = self.omiyageImage
            omiyageObject.average = Double(0)
            omiyageObject.createDate = self.currentDate
            
            //登録処理
            omiyageObject.save()
            
            //全部テキストフィールドを元に戻す
            self.omiyageImageView.contentMode = UIViewContentMode.ScaleToFill
            self.omiyageImage = UIImage(named: "noimage_omiyage_comment.jpg")
            self.omiyageImageView.image = self.omiyageImage
            self.titleTextField.text = ""
            self.detailTextField.text = ""

            
            //登録されたアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "完了",
                message: "入力データが登録されました。",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: saveComplete
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
        
    //登録が完了した際のアクション
    func saveComplete(ac: UIAlertAction) -> Void {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
