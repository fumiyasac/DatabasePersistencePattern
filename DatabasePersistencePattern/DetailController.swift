//
//  DetailController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import RealmSwift

class DetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextViewDelegate {
    
    //Outlet接続したもの
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailCommentTableView: UITableView!
    
    //メンバ変数
    var resultRealm: NSMutableArray = []
    
    var cellCount: Int!
    var cellSectionCount: Int = 1
    
    var selectedDb: Int!
    var detailId: Int!
    var detailTitle: String!
    
    //出現中の処理
    override func viewWillAppear(animated: Bool) {
        self.fetchAndReloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Debug.
        //print(self.detailId)
        //print(self.detailTitle)
        
        self.detailTitleLabel.text = self.detailTitle + "のコメント(Realm)"
        
        //自動計算の場合は必要
        self.detailCommentTableView.estimatedRowHeight = 90
        self.detailCommentTableView.rowHeight = UITableViewAutomaticDimension
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        //テーブルビューのデリゲート設定
        self.detailCommentTableView.delegate = self
        self.detailCommentTableView.dataSource = self
        
        //Xibのクラスを読み込む
        let nibDefault:UINib = UINib(nibName: "CommentCell", bundle: nil)
        self.detailCommentTableView.registerNib(nibDefault, forCellReuseIdentifier: "CommentCell")
    }
    
    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        
        //Realm選択時のアクション
        self.fetchObjectFromRealm()
    }
    
    //TableViewに関する設定一覧
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellSectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentCell
        
        cell!.commentStar.text = "⭐️評価:"
        
        //テキスト・画像等の表示(Realm)
        let omiyageCommentData: OmiyageComment = self.resultRealm[indexPath.row] as! OmiyageComment
        cell!.commentText.text = omiyageCommentData.comment
        let starAmount = NSString(format: "%d", omiyageCommentData.star) as String
        cell!.commentPoint.text = starAmount
            
        cell!.commentImage.image = omiyageCommentData.image
        
        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    //自動計算をする場合は不要
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(90.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func reloadData(){
        self.detailCommentTableView.reloadData()
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goCommentAdd" {
            let commentAddController = segue.destinationViewController as! CommentAddController
            commentAddController.selectedDb = self.selectedDb
            commentAddController.detailId = self.detailId
        }
    }
    
    //ボタンアクション
    @IBAction func addCommentAction(sender: UIButton) {
        performSegueWithIdentifier("goCommentAdd", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Realmでのデータ取得時の処理
    // ----- ↓↓↓Realm処理：ここから↓↓↓ -----
    func fetchObjectFromRealm() {
        
        self.resultRealm.removeAllObjects()
        
        let omiyages = OmiyageComment.fetchAllOmiyageList(self.detailId)
        
        self.cellCount = omiyages.count
        
        if self.cellCount != 0 {
            for omiyage in omiyages {
                self.resultRealm.addObject(omiyage)
            }
        }
        //Debug.
        //print(self.resultRealm)
        self.reloadData()
    }
    // ----- ↑↑↑Realm処理：ここまで↑↑↑ -----
    
}
