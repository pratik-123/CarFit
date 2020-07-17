//
//  ErrorResult.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
