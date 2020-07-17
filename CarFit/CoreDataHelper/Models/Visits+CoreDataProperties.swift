//
//  Visits+CoreDataProperties.swift
//  CarFit
//
//  Created by Pratik on 21/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//
//

import Foundation
import CoreData


extension Visits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visits> {
        return NSFetchRequest<Visits>(entityName: "Visits")
    }

    @NSManaged public var visitId: UUID?
    @NSManaged public var homeBobEmployeeId: UUID?
    @NSManaged public var houseOwnerId: UUID?
    @NSManaged public var isBlocked: NSNumber?
    @NSManaged public var startTimeUtc: Date?
    @NSManaged public var endTimeUtc: Date?
    @NSManaged public var title: String?
    @NSManaged public var isReviewed: NSNumber?
    @NSManaged public var isFirstVisit: NSNumber?
    @NSManaged public var isManual: NSNumber?
    @NSManaged public var houseOwnerFirstName: String?
    @NSManaged public var houseOwnerLastName: String?
    @NSManaged public var houseOwnerMobilePhone: String?
    @NSManaged public var houseOwnerAddress: String?
    @NSManaged public var houseOwnerZip: String?
    @NSManaged public var houseOwnerCity: String?
    @NSManaged public var houseOwnerLatitude: NSNumber?
    @NSManaged public var houseOwnerLongitude: NSNumber?
    @NSManaged public var isSubscriber: NSNumber?
    @NSManaged public var professional: String?
    @NSManaged public var visitState: String?
    @NSManaged public var stateOrder: NSNumber?
    @NSManaged public var expectedTime: String?
    @NSManaged public var hasTasks: NSSet?

}

// MARK: Generated accessors for hasTasks
extension Visits {

    @objc(addHasTasksObject:)
    @NSManaged public func addToHasTasks(_ value: Tasks)

    @objc(removeHasTasksObject:)
    @NSManaged public func removeFromHasTasks(_ value: Tasks)

    @objc(addHasTasks:)
    @NSManaged public func addToHasTasks(_ values: NSSet)

    @objc(removeHasTasks:)
    @NSManaged public func removeFromHasTasks(_ values: NSSet)

}
