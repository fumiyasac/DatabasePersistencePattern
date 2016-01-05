//
//  ViewController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2015/12/23.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {

    //Outlet接続したもの
    @IBOutlet weak var memoDataSearchBar: UISearchBar!
    @IBOutlet weak var memoDataSegment: UISegmentedControl!
    @IBOutlet weak var memoDataTableView: UITableView!
    
    //変数＆定数
    var dbDefinitionValue : Int! = DbDefinition.RealmUse.rawValue
    var sortDefinitionValue: Int! = SortDefinition.SortId.rawValue
    
    var sortOrder: String! = ""
    var containsParameter: String! = ""
    
    var searchResultRealm: NSMutableArray = []
    
    var commentCount: Int = 0
    var averageAmount: Double = 0.0
    
    var searchActive: Bool = false
    
    var cellCount: Int!
    var cellSectionCount: Int = 1
    
    //出現中の処理
    override func viewWillAppear(animated: Bool) {
        self.fetchAndReloadData()
    }
    
    //出現後の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        //検索バーのデリゲート設定
        self.memoDataSearchBar.delegate = self
        self.memoDataSearchBar.showsCancelButton = true
        self.memoDataSearchBar.placeholder = "検索したい文字を入力"

        //テーブルビューのデリゲート設定
        self.memoDataTableView.delegate = self
        self.memoDataTableView.dataSource = self
        self.memoDataTableView.allowsSelection = true
        
        //Xibのクラスを読み込む
        let nibDefault:UINib = UINib(nibName: "ListCell", bundle: nil)
        self.memoDataTableView.registerNib(nibDefault, forCellReuseIdentifier: "ListCell")
    }
    
    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        self.fetchObjectFromRealm()
    }
    
    //SearchBarに関する設定一覧
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.containsParameter = searchText
        self.changeFetchTargetDb(self.dbDefinitionValue)
        
        self.view.endEditing(true)
        
        if self.cellCount == 0 {
            self.searchActive = false
        } else {
            self.searchActive = true
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as? ListCell
        
        
        //テキスト・画像等の表示(Realm)
        let omiyageData: Omiyage = self.searchResultRealm[indexPath.row] as! Omiyage
            
        cell!.listTitle.text = omiyageData.title
        cell!.listComments.text = omiyageData.detail

        cell!.listDate.text = ConvertNSDate.convertNSDateToString(omiyageData.createDate)

        let averageRatio = NSString(format: "%.1f", omiyageData.average) as String
        cell!.listAverage.text = "⭐️" + averageRatio + "点"
            
        cell!.listImage.image = omiyageData.image

        cell!.listImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell!.listImage.userInteractionEnabled = false

        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //テキスト・画像等の表示(Realm)
        let omiyageData: Omiyage = self.searchResultRealm[indexPath.row] as! Omiyage
        let dict: NSDictionary = [
            "id" : omiyageData.id,
            "title" : omiyageData.title
        ]
        performSegueWithIdentifier("goDetail", sender: dict)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(160.0)
    }
    
    func reloadData(){
        self.memoDataTableView.reloadData()
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goAdd" {
            
            let addController = segue.destinationViewController as! AddController
            addController.selectedDb = self.dbDefinitionValue
            
        } else if segue.identifier == "goDetail" {
            
            let detailController = segue.destinationViewController as! DetailController
            let detailDataBean = sender as? NSDictionary
                
            detailController.selectedDb = self.dbDefinitionValue
            detailController.detailId = detailDataBean!["id"] as? Int
            detailController.detailTitle = detailDataBean!["title"] as? String
        }
    }
    
    //ボタンアクション
    @IBAction func memoDataCommentSort(sender: UIBarButtonItem) {
        self.sortDefinitionValue = SortDefinition.SortScore.rawValue
        self.changeFetchTargetDb(self.dbDefinitionValue)
    }
    
    @IBAction func memoDataDateSort(sender: UIBarButtonItem) {
        self.sortDefinitionValue = SortDefinition.SortId.rawValue
        self.changeFetchTargetDb(self.dbDefinitionValue)
    }
    
    @IBAction func memoDataAdd(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goAdd", sender: nil)
    }
    
    //セグメントコントロールの切り替え
    @IBAction func segmentChangeAction(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
            
        case DbDefinition.RealmUse.rawValue:
            self.dbDefinitionValue = DbDefinition.RealmUse.rawValue
            break
        default:
            self.dbDefinitionValue = DbDefinition.RealmUse.rawValue
            break
        }
        self.changeFetchTargetDb(self.dbDefinitionValue)
        
    }
    
    //値によって読み込むDbを変更する
    func changeFetchTargetDb(dbDefinitionValue: Int) {
        self.fetchObjectFromRealm()
    }
    
    //Realmでのデータ取得時の処理
    // ----- ↓↓↓Realm処理：ここから↓↓↓ -----
    func fetchObjectFromRealm() {
        
        self.searchResultRealm.removeAllObjects()
        
        if self.sortDefinitionValue == SortDefinition.SortId.rawValue {
            self.sortOrder = "id"
        } else {
            self.sortOrder = "average"
        }
        
        let omiyages = Omiyage.fetchAllOmiyageList("\(self.sortOrder)", containsParameter: self.containsParameter)
        
        self.cellCount = omiyages.count
        
        if self.cellCount != 0 {
            for omiyage in omiyages {
                self.searchResultRealm.addObject(omiyage)
            }
        }
        //Debug.
        //print(self.searchResultRealm)
        
        self.memoDataSegment.selectedSegmentIndex = DbDefinition.RealmUse.rawValue
        
        self.reloadData()
    }
    // ----- ↑↑↑Realm処理：ここまで↑↑↑ -----
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

