//
//  DbDefinition.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/05.
//  Copyright © 2016年 just1factory. All rights reserved.
//

//格納用DBの選択enum
enum DbDefinition: Int {
    
    //セグメント番号の名称
    case RealmUse, CoreDataUse
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}
