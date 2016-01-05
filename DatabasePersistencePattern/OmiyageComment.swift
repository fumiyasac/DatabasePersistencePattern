//
//  OmiyageComment.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/05.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//Realmクラスのインポート
import RealmSwift

class OmiyageComment: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()
    
    //id
    dynamic var id = 0
    
    //おみやげid
    dynamic var omiyage_id = 0
    
    //コメント
    dynamic var comment = ""
    
    //評価
    dynamic var star = 0
    
    //その時の写真
    /**
    * 下記記事で紹介されている実装を元に作成
    *
    * JFYI：(Qiita) Realm × Swift2 でシームレスに画像を保存する
    * http://qiita.com/_ha1f/items/593ca4f9c97ae697fc75
    *
    */
    //
    dynamic private var _image: UIImage? = nil
    
    dynamic var image: UIImage? {
        
        //画像のセッター
        set {
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        
        //画像のゲッター
        get {
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    dynamic private var imageData: NSData? = nil
    
    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //保存しないプロパティの一覧
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    //新規追加用のインスタンス生成メソッド
    static func create() -> OmiyageComment {
        let omiyageComment = OmiyageComment()
        omiyageComment.id = self.getLastId()
        return omiyageComment
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let omiyageComment = realm.objects(OmiyageComment).last {
            return omiyageComment.id + 1
        } else {
            return 1
        }
    }
    
    //インスタンス保存用メソッド
    func save() {
        try! OmiyageComment.realm.write {
            OmiyageComment.realm.add(self)
        }
    }
    
    //平均値を取得
    static func getAverage(target_id: Int) -> Double {
        
        if let average: Double = realm.objects(OmiyageComment).filter("omiyage_id = %@", target_id).average("star") {
            return average
        } else {
            return 0.0
        }
    }
    
    //インスタンス削除用メソッド
    func delete() {
        try! OmiyageComment.realm.write {
            OmiyageComment.realm.delete(self)
        }
    }
    
    //ソートをかけた順のデータの全件取得をする
    static func fetchAllOmiyageList(target_id: Int) -> [OmiyageComment] {
        
        var omiyageComments: Results<OmiyageComment>
        omiyageComments = realm.objects(OmiyageComment).filter("omiyage_id = %@", target_id).sorted("id", ascending: true)
        
        var omiyageCommentList: [OmiyageComment] = []
        for omiyageComment in omiyageComments {
            omiyageCommentList.append(omiyageComment)
        }
        return omiyageCommentList
    }
    
}


