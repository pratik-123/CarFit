//
//  TaskPO.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
struct TaskPO {
    let houseOwnerFirstName: String?
    let houseOwnerLastName: String?
    let visitState: String?
    let startTime: String?
    let startTimeUtc: Date?
    let expectedTime: String?
    let houseOwnerAddress: String?
    let houseOwnerZip: String?
    let houseOwnerCity: String?
    let houseOwnerLatitude: NSNumber?
    let houseOwnerLongitude: NSNumber?
    let taskDateUtc: Date?
    let taskTitle: String?
    let taskTimesInMinutes: NSNumber?
    
    init(taskObject: Tasks, dateFormater: DateFormatter) {
        let objVisit = taskObject.belongsToVisit
        var startTime : String?
        if let date = objVisit?.startTimeUtc {
            startTime = dateFormater.string(from:  date)
        }
        self.houseOwnerFirstName = objVisit?.houseOwnerFirstName
        self.houseOwnerLastName = objVisit?.houseOwnerLastName
        self.visitState = objVisit?.visitState
        self.startTime = startTime
        self.startTimeUtc = objVisit?.startTimeUtc
        self.expectedTime = objVisit?.expectedTime
        self.houseOwnerAddress = objVisit?.houseOwnerAddress
        self.houseOwnerZip = objVisit?.houseOwnerZip
        self.houseOwnerCity = objVisit?.houseOwnerCity
        self.houseOwnerLatitude = objVisit?.houseOwnerLatitude
        self.houseOwnerLongitude = objVisit?.houseOwnerLongitude
        self.taskDateUtc = taskObject.createDateUtc
        self.taskTitle = taskObject.title
        self.taskTimesInMinutes = taskObject.timesInMinutes
    }
    
    var customer : String? {
        var name = houseOwnerFirstName ?? ""
        if houseOwnerLastName != nil {
            name += " " + (houseOwnerLastName ?? "")
        }
        return name
    }
    
    var arrivalTime : String? {
        var returnTime = String()
        returnTime = startTime ?? ""
        if expectedTime != nil {
            returnTime += ("/" + (expectedTime ?? ""))
        }
        return returnTime
    }
    
    var destination: String? {
        var address = houseOwnerAddress ?? ""
        if houseOwnerZip != nil {
            address += (" " + (houseOwnerZip ?? ""))
        }
        if houseOwnerCity != nil {
            address += (" " + (houseOwnerCity ?? ""))
        }
        return address
    }
    
}
