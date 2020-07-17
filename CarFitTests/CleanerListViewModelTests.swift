//
//  CleanerListViewModelTests.swift
//  CarFitTests
//
//  Created by Pratik on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit
class CleanerListViewModelTests: XCTestCase {
    
    var viewModel : CleanerListViewModel!
    fileprivate var service : MockVisitService!
    
    override func setUp() {
        super.setUp()
        self.service = MockVisitService()
        self.viewModel = CleanerListViewModel(service: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testFetchWithNoService() {
        let expectation = XCTestExpectation(description: "No service found")
        // set service to nil
        viewModel.service = nil
        // expected error for no service found
        viewModel.onErrorHandling = { _ in
            expectation.fulfill()
        }
        viewModel.fetchVisit()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWithData() {
        let expectation = XCTestExpectation(description: "Visit found")
        service.visitModel = VisitBaseModel(success: true, message: nil, code: 200, data: [])
        // expected response
        viewModel.onRefreshHandling = { _ in
            expectation.fulfill()
        }
        viewModel.fetchVisit()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchTaskWithData() {
        let expectation = XCTestExpectation(description: "Task found")
        // expected response
        viewModel.onRefreshHandling = { _ in
            expectation.fulfill()
        }
        viewModel.fetchTasks()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate class MockVisitService : ServiceProtocol {
    
    var  visitModel : VisitBaseModel?
    func fetchVisitsDataFromFile(completion: @escaping ((Result<VisitBaseModel, ErrorResult>) -> Void)) {
        if let visitModel = visitModel {
            completion(Result.success(visitModel))
        } else {
            completion(Result.failure(ErrorResult.custom(string: "No data found")))
        }
    }
    
    func fetchTasks(completion: @escaping ((Result<[TaskPO], ErrorResult>) -> Void)) {
        completion(Result.success([]))
    }
}
