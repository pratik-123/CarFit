//
//  Visits+CoreDataClass.swift
//  CarFit
//
//  Created by Pratik on 21/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Visits)
public class Visits: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case visitId = "visitId"
        case homeBobEmployeeId = "homeBobEmployeeId"
        case houseOwnerId = "houseOwnerId"
        case isBlocked = "isBlocked"
        case startTimeUtc = "startTimeUtc"
        case endTimeUtc = "endTimeUtc"
        case title = "title"
        case isReviewed = "isReviewed"
        case isFirstVisit = "isFirstVisit"
        case isManual = "isManual"
        case houseOwnerFirstName = "houseOwnerFirstName"
        case houseOwnerLastName = "houseOwnerLastName"
        case houseOwnerMobilePhone = "houseOwnerMobilePhone"
        case houseOwnerAddress = "houseOwnerAddress"
        case houseOwnerZip = "houseOwnerZip"
        case houseOwnerCity = "houseOwnerCity"
        case houseOwnerLatitude = "houseOwnerLatitude"
        case houseOwnerLongitude = "houseOwnerLongitude"
        case isSubscriber = "isSubscriber"
        case professional = "professional"
        case visitState = "visitState"
        case stateOrder = "stateOrder"
        case expectedTime = "expectedTime"
        case tasks = "tasks"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Visits", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.visitId = try container.decode(UUID.self, forKey: .visitId)
        self.homeBobEmployeeId = try container.decode(UUID.self, forKey: .homeBobEmployeeId)
        self.houseOwnerId = try container.decode(UUID.self, forKey: .houseOwnerId)
        self.title = try container.decode(String.self, forKey: .title)
        self.houseOwnerFirstName = try container.decode(String.self, forKey: .houseOwnerFirstName)
        self.houseOwnerLastName = try container.decode(String.self, forKey: .houseOwnerLastName)
        self.houseOwnerMobilePhone = try container.decode(String.self, forKey: .houseOwnerMobilePhone)
        self.houseOwnerAddress = try container.decode(String.self, forKey: .houseOwnerAddress)
        self.houseOwnerZip = try container.decode(String.self, forKey: .houseOwnerZip)
        self.houseOwnerCity = try container.decode(String.self, forKey: .houseOwnerCity)
        self.professional = try container.decode(String.self, forKey: .professional)
        self.visitState = try container.decode(String.self, forKey: .visitState)
        self.expectedTime = try? container.decode(String.self, forKey: .expectedTime)
        if let isBlocked = try? container.decodeIfPresent(Bool.self, forKey: .isBlocked) {
            self.isBlocked = NSNumber(value: isBlocked)
        }
        if let isReviewed = try? container.decodeIfPresent(Bool.self, forKey: .isReviewed) {
            self.isReviewed = NSNumber(value: isReviewed)
        }
        if let isFirstVisit = try? container.decodeIfPresent(Bool.self, forKey: .isFirstVisit) {
            self.isFirstVisit = NSNumber(value: isFirstVisit)
        }
        if let isManual = try? container.decodeIfPresent(Bool.self, forKey: .isManual) {
            self.isManual = NSNumber(value: isManual)
        }
        if let isSubscriber = try? container.decodeIfPresent(Bool.self, forKey: .isSubscriber) {
            self.isSubscriber = NSNumber(value: isSubscriber)
        }
        if let houseOwnerLatitude = try? container.decodeIfPresent(Double.self, forKey: .houseOwnerLatitude) {
            self.houseOwnerLatitude = NSNumber(value: houseOwnerLatitude)
        }
        if let houseOwnerLongitude = try? container.decodeIfPresent(Double.self, forKey: .houseOwnerLongitude) {
            self.houseOwnerLongitude = NSNumber(value: houseOwnerLongitude)
        }
        if let stateOrder = try? container.decodeIfPresent(Double.self, forKey: .stateOrder) {
            self.stateOrder = NSNumber(value: stateOrder)
        }
        if let startTimeUtc = try? container.decodeIfPresent(Date.self, forKey: .startTimeUtc) {
            self.startTimeUtc = startTimeUtc
        }
        if let endTimeUtc = try? container.decodeIfPresent(Date.self, forKey: .endTimeUtc) {
            self.endTimeUtc = endTimeUtc
        }
        
        if let array = try? container.decodeIfPresent([Tasks].self, forKey: .tasks) {
            hasTasks = NSSet(array: array)
        }
    }
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
    }
}
