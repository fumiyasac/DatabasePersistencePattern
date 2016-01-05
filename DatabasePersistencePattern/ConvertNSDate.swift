//
//  ConvertNSDate.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/05.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//日付をNSDateからStringの変換用のstruct
struct ConvertNSDate {
    
    //NSDate → Stringへの変換
    static func convertNSDateToString (date: NSDate) -> String {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }
}