//
//  CommentAddController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import RealmSwift

class CommentAddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Outlet接続するもの
    @IBOutlet weak var selectedCommentDbText: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var starSegmentControl: UISegmentedControl!
    @IBOutlet weak var commentImageView: UIImageView!
    
    //変数＆定数
    var selectedDb: Int!
    var detailId: Int!
    
    var omiyageCommentStar: Int = 1
    var omiyageCommentDetail: String!
    var omiyageCommentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        self.commentImageView.contentMode = UIViewContentMode.ScaleToFill
        self.omiyageCommentImage = UIImage(named: "noimage_omiyage_comment.jpg")
        self.commentImageView.image = self.omiyageCommentImage
        
        self.selectedCommentDbText.text = "選択したデータベース：Realm"
        
        //UITextFieldのデリゲート設定
        self.commentTextField.delegate = self
        self.commentTextField.placeholder = "※コメントを詳しく書いてね。"
        
    }
    
    //ボタンアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func changeStarAction(sender: UISegmentedControl) {
        self.omiyageCommentStar = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func omiyageCommentImageAction(sender: UIButton) {
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "おみやげにコメント＆評価をする",
            message: "是非あたたかいコメントをお願いします(^^)",
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
        self.commentImageView.image = UIImage(CGImage: cgImage!)
    }
    
    @IBAction func addOmiyageCommentDataAction(sender: UIButton) {
        
        //UIImageデータを取得する
        self.omiyageCommentImage = self.commentImageView.image
        
        //バリデーションを通す前の準備
        self.omiyageCommentDetail = self.commentTextField.text
        
        //Error:UIAlertControllerでエラーメッセージ表示
        if (self.omiyageCommentDetail.isEmpty) {
            
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
            let omiyageCommentObject = OmiyageComment.create()
            omiyageCommentObject.comment = self.omiyageCommentDetail
            omiyageCommentObject.star = self.omiyageCommentStar
            omiyageCommentObject.image = self.omiyageCommentImage
            omiyageCommentObject.omiyage_id = self.detailId
                
            //登録処理
            omiyageCommentObject.save()
                
            //平均値を更新
            let average = OmiyageComment.getAverage(self.detailId)
            Omiyage.updateAverage(average, target_id: self.detailId)
            
            //全部テキストフィールドを元に戻す
            self.commentImageView.contentMode = UIViewContentMode.ScaleToFill
            self.omiyageCommentImage = UIImage(named: "noimage_omiyage_comment.jpg")
            self.commentImageView.image = self.omiyageCommentImage
            self.commentTextField.text = ""
            
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
