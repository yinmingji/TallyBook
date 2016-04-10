//
//  BillManagedObject+CoreDataProperties.swift
//  TallyBook
//
//  Created by QianluFan on 4/8/16.
//  Copyright © 2016 YinmingJi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BillManagedObject {

    @NSManaged var date: NSDate?
    @NSManaged var expense: NSNumber?
    @NSManaged var category: String?
    @NSManaged var categoryImage: String?
    @NSManaged var user: String?
    @NSManaged var income: NSNumber?
    @NSManaged var remark: String?
    @NSManaged var images: NSData?

}
