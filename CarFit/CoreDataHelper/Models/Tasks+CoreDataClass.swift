//
//  Tasks+CoreDataClass.swift
//  CarFit
//
//  Created by Pratik on 21/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tasks)
public class Tasks: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case taskId = "taskId"
        case title = "title"
        case isTemplate = "isTemplate"
        case timesInMinutes = "timesInMinutes"
        case price = "price"
        case paymentTypeId = "paymentTypeId"
        case createDateUtc = "createDateUtc"
        case lastUpdateDateUtc = "lastUpdateDateUtc"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.taskId = try container.decode(UUID.self, forKey: .taskId)
        self.paymentTypeId = try container.decode(UUID.self, forKey: .paymentTypeId)
        self.title = try container.decode(String.self, forKey: .title)
        if let isTemplate = try? container.decodeIfPresent(Bool.self, forKey: .isTemplate) {
            self.isTemplate = NSNumber(value: isTemplate)
        }
        if let timesInMinutes = try? container.decodeIfPresent(Double.self, forKey: .timesInMinutes) {
            self.timesInMinutes = NSNumber(value: timesInMinutes)
        }
        if let price = try? container.decodeIfPresent(Double.self, forKey: .price) {
            self.price = NSNumber(value: price)
        }
        let formatter = DateFormaterEnum.formate(type: .dateTimeUTC1)
        let createDateUtcString = try container.decode(String.self, forKey: .createDateUtc)
        if let createDateUtc = formatter.date(from: createDateUtcString) {
            self.createDateUtc = createDateUtc
        }
        let lastUpdateDateUtcString = try container.decode(String.self, forKey: .lastUpdateDateUtc)
        if let lastUpdateDateUtc = formatter.date(from: lastUpdateDateUtcString) {
            self.lastUpdateDateUtc = lastUpdateDateUtc
        }
    }
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
    }
}
