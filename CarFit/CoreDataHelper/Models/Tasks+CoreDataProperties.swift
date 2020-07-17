//
//  Tasks+CoreDataProperties.swift
//  CarFit
//
//  Created by Pratik on 21/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var taskId: UUID?
    @NSManaged public var title: String?
    @NSManaged public var isTemplate: NSNumber?
    @NSManaged public var timesInMinutes: NSNumber?
    @NSManaged public var price: NSNumber?
    @NSManaged public var paymentTypeId: UUID?
    @NSManaged public var createDateUtc: Date?
    @NSManaged public var lastUpdateDateUtc: Date?
    @NSManaged public var belongsToVisit: Visits?

}
