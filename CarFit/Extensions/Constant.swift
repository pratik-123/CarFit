//
//  Constant.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
struct APIStatusCode {
    static let ok = 200
}

enum DateFormaterEnum : String {
    ///"HH:mm"
    case onlyTime = "HH:mm"
    ///"yyyy-MM-dd'T'HH:mm:ss"
    case dateTimeUTC = "yyyy-MM-dd'T'HH:mm:ss"
    ///"yyyy-MM-dd'T'HH:mm:ss.SSS"
    case dateTimeUTC1 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    ///"yyyy-MM-dd"
    case onlyDate = "yyyy-MM-dd"
    ///"d"
    case onlyDay = "d"
    ///"EEE"
    case onlyWeekDay = "EEE"
    ///"MMMM yyyy"
    case onlyMonthYear = "MMMM yyyy"
    
    static func formate(type : DateFormaterEnum) -> DateFormatter {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = type.rawValue
        return dateFormate
    }
}
