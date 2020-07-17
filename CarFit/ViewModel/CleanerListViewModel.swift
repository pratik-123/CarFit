//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class CleanerListViewModel {
    weak var service: ServiceProtocol?
    var onRefreshHandling : ((RefreshTypeEnum?) -> Void)?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    /// Selected date store
    var selectedDate : Date?
    /// Task array of all object
    private var allTaskArray = [TaskPO]() {
        didSet {
            fiteredDataBasedOnSelectedDate()
        }
    }
    /// Filtered value store based on selected date
    private var filteredTaskArray = [TaskPO]()
    
    enum RefreshTypeEnum {
        case Visit,Task
    }
    
    init(service: ServiceProtocol = DataService.shared) {
        self.service = service
        //set current date as default
        self.selectedDate = Date()
    }
    
    /// Fetch visit from backend right now fetch data from json file
    func fetchVisit() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service init"))
            return
        }
        service.fetchVisitsDataFromFile { (result) in
            switch result {
            case .success(let data):
                if data.code == APIStatusCode.ok {
                    self.onRefreshHandling?(.Visit)
                    self.fetchTasks()
                } else {
                    self.onErrorHandling?(ErrorResult.custom(string: data.message ?? ""))
                }
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(ErrorResult.network(string: error.localizedDescription))
                break
            }
        }
    }

    /// Fetch all task from local db
    func fetchTasks() {
        service?.fetchTasks(completion: { (result) in
            switch result {
            case .success(let array):
                self.allTaskArray = array
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(ErrorResult.network(string: error.localizedDescription))
                break
            }
        })
    }
    
    /// selected date set and based on date filter data
    /// - Parameter date: date
    func setSelectedDate(date : Date) {
        selectedDate = date
        fiteredDataBasedOnSelectedDate()
    }
    /// Filter array based on selected date
    private func fiteredDataBasedOnSelectedDate() {
        let formatter = DateFormaterEnum.formate(type: .onlyDate)
        if let selectedDate = selectedDate {
            let dateString = formatter.string(from: selectedDate)
            filteredTaskArray = allTaskArray.filter { (taskObject) -> Bool in
                if let taskDate = taskObject.taskDateUtc {
                    let taskDateString = formatter.string(from: taskDate)
                    return (dateString == taskDateString)
                }
                return false
            }
            filteredTaskArray = filteredTaskArray.sorted(by: { ($0.taskDateUtc ?? Date()) < ($1.taskDateUtc ?? Date()) })
        }
        self.onRefreshHandling?(.Task)
    }
}
extension CleanerListViewModel {
    ///number of task return
    func numberOfRows() -> Int {
        return filteredTaskArray.count
    }
    
    /// Previous task get
    /// - Parameter index: index object
    /// - Returns: task object
    func getPreviousTask(at index: Int) -> TaskPO? {
        let previousIndex = index - 1
        if previousIndex >= 0, filteredTaskArray.indices.contains(previousIndex) {
            return filteredTaskArray[previousIndex]
        }
        return nil
    }
    
    /// Task object get based on index
    /// - Parameter index: index of object
    /// - Returns: Task object
    func getTask(at index: Int) -> TaskPO? {
        if filteredTaskArray.indices.contains(index) {
            return filteredTaskArray[index]
        }
        return nil
    }
}
