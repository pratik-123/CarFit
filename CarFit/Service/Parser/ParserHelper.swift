//
//  ParserHelper.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import CoreData

protocol Parseable {
    func parse<T: Decodable>(_ type: T.Type, from data: Data, completion: @escaping (Result<T, ErrorResult>) -> Void)
}

extension Parseable {
    /// Parsable data with local db using codable protocol
    /// - Parameters:
    ///   - type: class type generic
    ///   - data: data
    ///   - completion: completion handler
    func parse<T: Decodable>(_ type: T.Type, from data: Data, completion: @escaping (Result<T, ErrorResult>) -> Void) {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (managedObjectContext) in
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let decoder = JSONDecoder()
            let dateFormatter = DateFormaterEnum.formate(type: .dateTimeUTC)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            //context store which use in manage object class
            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = managedObjectContext
            }
            
            do {
                let parseObject = try decoder.decode(type.self, from: data)
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
                completion(.success(parseObject))
            } catch {
                print(error)
                completion(.failure(.parser(string: error.localizedDescription)))
            }
        }
    }
}
