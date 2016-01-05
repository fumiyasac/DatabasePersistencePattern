//
//  SortDedinition.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/05.
//  Copyright © 2016年 just1factory. All rights reserved.
//

//ソートの選択enum
enum SortDefinition: Int {
    
    //セグメント番号の名称
    case SortScore, SortId
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}
