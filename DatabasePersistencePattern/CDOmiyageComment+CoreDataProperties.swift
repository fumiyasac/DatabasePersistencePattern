//
//  CDOmiyageComment+CoreDataProperties.swift
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

extension CDOmiyageComment {

    @NSManaged var cd_comment_comment: String?
    @NSManaged var cd_comment_id: NSNumber?
    @NSManaged var cd_comment_imageData: NSData?
    @NSManaged var cd_comment_star: NSNumber?
    @NSManaged var cd_id: NSNumber?

}
