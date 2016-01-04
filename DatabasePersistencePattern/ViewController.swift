//
//  ViewController.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2015/12/23.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//格納用DBの選択enum
enum DbDefinition: Int {
    
    //セグメント番号の名称
    case RealmUse, CoreDataUse
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}

//ソートの選択enum
enum SortDefinition: Int {
    
    //セグメント番号の名称
    case SortScore, SortDate
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}

//メインのビューコントローラー
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {

    //Outlet接続したもの
    @IBOutlet weak var memoDataSearchBar: UISearchBar!
    @IBOutlet weak var memoDataSegment: UISegmentedControl!
    @IBOutlet weak var memoDataTableView: UITableView!
    
    //変数＆定数
    var dbDefinitionValue : Int!
    var sortDefinitionValue: Int!
    
    var seachResultArray: NSMutableArray = []
    
    var searchActive: Bool = false
    
    var cellCount: Int!
    var cellSectionCount: Int = 1
    
    //出現中の処理
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //出現後の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //デフォルト選択
        self.dbDefinitionValue = DbDefinition.RealmUse.rawValue
        self.sortDefinitionValue = SortDefinition.SortDate.rawValue
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        //検索バーのデリゲート設定
        self.memoDataSearchBar.delegate = self
        
        //テーブルビューのデリゲート設定
        self.memoDataTableView.delegate = self
        self.memoDataTableView.dataSource = self
        
        //Xibのクラスを読み込む
        let nibDefault:UINib = UINib(nibName: "ListCell", bundle: nil)
        self.memoDataTableView.registerNib(nibDefault, forCellReuseIdentifier: "ListCell")
    }

    //SearchBarに関する設定一覧
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.cellCount == 0 {
            self.searchActive = false
        } else {
            self.searchActive = true
        }
        self.reloadData()
    }
    
    //TableViewに関する設定一覧
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellSectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //self.cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as? ListCell
        
        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        }
    }
    
    //ボタンアクション
    @IBAction func memoDataCommentSort(sender: UIBarButtonItem) {
        self.sortDefinitionValue = SortDefinition.SortScore.rawValue
        self.changeFetchTargetDb(self.dbDefinitionValue, sortDefinitionValue: self.sortDefinitionValue)
    }
    
    @IBAction func memoDataDateSort(sender: UIBarButtonItem) {
        self.sortDefinitionValue = SortDefinition.SortDate.rawValue
        self.changeFetchTargetDb(self.dbDefinitionValue, sortDefinitionValue: self.sortDefinitionValue)
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
            
        case DbDefinition.CoreDataUse.rawValue:
            //コメントアウト
            //self.dbDefinitionValue = DbDefinition.CoreDataUse.rawValue
            break
            
        default:
            self.dbDefinitionValue = DbDefinition.RealmUse.rawValue
            break
        }
        self.changeFetchTargetDb(self.dbDefinitionValue, sortDefinitionValue: self.sortDefinitionValue)
    }
    
    //値によって読み込むDbを変更する
    func changeFetchTargetDb(dbDefinitionValue: Int, sortDefinitionValue: Int) -> NSMutableArray {
        
        var targetArray: NSMutableArray = []
        if dbDefinitionValue == DbDefinition.RealmUse.rawValue {
            targetArray = self.changeDataToRealm(sortDefinitionValue)
        } else {
            targetArray = self.changeDataToCoreData(sortDefinitionValue)
        }
        return targetArray
    }

    //CoreDataからデータをフェッチする
    func changeDataToCoreData(sort: Int) -> NSMutableArray {
        
        //var targetArray: NSMutableArray = []
        let targetArray: NSMutableArray = []
        
        return targetArray
    }
    
    //Realmからデータをフェッチする
    func changeDataToRealm(sort: Int) -> NSMutableArray {
        
        //var targetArray: NSMutableArray = []
        let targetArray: NSMutableArray = []
        
        return targetArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

