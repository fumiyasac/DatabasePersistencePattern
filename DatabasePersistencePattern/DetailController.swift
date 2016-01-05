//
//  DetailController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/03.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class DetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextViewDelegate {
    
    //Outlet接続したもの
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailCommentTableView: UITableView!
    
    //メンバ変数
    var resultRealm: NSMutableArray = []
    var resultCoreData: AnyObject?
    
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
        
        //Realmのとき
        if self.selectedDb == DbDefinition.RealmUse.rawValue {
            
            self.detailTitleLabel.text = self.detailTitle + "のコメント(Realm)"
        
        //CoreDataのとき
        } else {
            
            self.detailTitleLabel.text = self.detailTitle + "のコメント(CoreData)"
        }
        
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
        
        if self.selectedDb == DbDefinition.RealmUse.rawValue {
            
            //Realm選択時のアクション
            self.fetchObjectFromRealm()
            
        } else {
            
            //CoreData選択時のアクション
            self.fetchObjectFromCoreData()
            
        }
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
        
        //Realmのとき
        if self.selectedDb == DbDefinition.RealmUse.rawValue {
            
            //テキスト・画像等の表示(Realm)
            let omiyageCommentData: OmiyageComment = self.resultRealm[indexPath.row] as! OmiyageComment
            cell!.commentText.text = omiyageCommentData.comment
            let starAmount = NSString(format: "%d", omiyageCommentData.star) as String
            cell!.commentPoint.text = starAmount
            
            cell!.commentImage.image = omiyageCommentData.image
            
        //CoreDataのとき
        } else {
            
            //テキスト・画像等の表示(CoreData)
            let cdOmiyageCommentData: AnyObject? = self.resultCoreData?.objectAtIndex(indexPath.row)
            cell!.commentText.text = cdOmiyageCommentData?.valueForKey("cd_comment_comment") as? String
            let dispStar = cdOmiyageCommentData?.valueForKey("cd_comment_star") as! Int
            let starAmount = NSString(format: "%d", dispStar) as String
            cell!.commentPoint.text = starAmount
            
            let dispImg: NSData = cdOmiyageCommentData?.valueForKey("cd_comment_imageData") as! NSData
            cell!.commentImage.image = UIImage(data: dispImg)
        }
        
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
    
    //CoreDataでのデータ取得時の処理
    // ----- ↓↓↓CoreData処理：ここから↓↓↓ -----
    func fetchObjectFromCoreData() {
        
        var error: NSError?
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext
        
        //フェッチリクエストと条件の設定
        let fetchRequest = NSFetchRequest(entityName: "CDOmiyageComment")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"cd_id = \(self.detailId)")
        
        let sortDescriptor = NSSortDescriptor(key: "cd_comment_id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //フェッチ結果
        let fetchResults: [AnyObject]?
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchResults = nil
        }
        
        //データの取得処理成功時
        if let results: AnyObject = fetchResults {
            
            self.cellCount = results.count
            
            if self.cellCount != 0 {
                self.resultCoreData = results
            }
            //Debug.
            //print(self.resultCoreData)
            
            //失敗時
        } else {
            print("Could not fetch \(error) , \(error!.userInfo)")
        }
        self.reloadData()
    }
    // ----- ↑↑↑CoreData処理：ここまで↑↑↑ -----
    
}
