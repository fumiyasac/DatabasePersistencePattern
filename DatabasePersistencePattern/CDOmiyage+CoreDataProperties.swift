//
//  CDOmiyage+CoreDataProperties.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/05.
//  Copyright © 2016年 just1factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDOmiyage {

    @NSManaged var cd_average: NSNumber?
    @NSManaged var cd_createDate: NSDate?
    @NSManaged var cd_detail: String?
    @NSManaged var cd_id: NSNumber?
    @NSManaged var cd_imageData: NSData?
    @NSManaged var cd_title: String?

}
