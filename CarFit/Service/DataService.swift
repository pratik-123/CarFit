//
//  DataService.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

protocol ServiceProtocol: class {
    func fetchVisitsDataFromFile(completion:@escaping ((Result<VisitBaseModel, ErrorResult>) -> Void))
    func fetchTasks(completion:@escaping ((Result<[TaskPO], ErrorResult>) -> Void))
}

final class DataService: ServiceProtocol, Parseable {
    static let shared = DataService()
    
    /// Fetch data from local file and parse and store in local db
    /// - Parameter completion: completion block
    func fetchVisitsDataFromFile(completion: @escaping ((Result<VisitBaseModel, ErrorResult>) -> Void)) {
        // read json file
        guard let data = FileManager.readFile(forResource: "carfit") else {
            completion(.failure(.custom(string: "File not found")))
            return
        }
        parse(VisitBaseModel.self, from: data, completion: completion)
    }
    
    /// Task fetch from local db
    /// - Parameter completion: array of task po object
    func fetchTasks(completion:@escaping ((Result<[TaskPO], ErrorResult>) -> Void)) {
        let arrayOfData = CoreDataManager.shared.persistentContainer.viewContext.fetchData(entity: Tasks.self)
        if let array = arrayOfData as? [Tasks] {
            let dateFormater = DateFormaterEnum.formate(type: .onlyTime)
             let returnArray = array.map { (objTask) -> TaskPO in
                let po = TaskPO(taskObject: objTask, dateFormater: dateFormater)
                return po
            }
            completion(.success(returnArray))
        } else {
            completion(.success([]))
        }
    }
}
