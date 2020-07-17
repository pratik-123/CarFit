//
//  VisitBaseModel.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
struct VisitBaseModel : Codable {
    let success: Bool
    let message: String?
    let code: Int
    let data: [Visits]?
}
