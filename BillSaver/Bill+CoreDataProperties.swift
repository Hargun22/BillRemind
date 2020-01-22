//
//  Bill+CoreDataProperties.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2020-01-02.
//  Copyright © 2020 Hargun Bedi. All rights reserved.
//
//

import Foundation
import CoreData


extension Bill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }

    @NSManaged public var title: String?
    @NSManaged public var reminderFrequency: String?
    @NSManaged public var date: Date?
    @NSManaged public var identifier: String?

}
