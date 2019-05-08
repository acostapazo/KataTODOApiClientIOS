//
//  TODOByTaskTests.swift
//  KataTODOAPIClientTests
//
//  Created by Artur Costa-Pazo on 08/05/2019.
//  Copyright © 2019 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import Nimble
import XCTest
import Result
@testable import KataTODOAPIClient

class TODOByTaskTests: NocillaTestCase {
    
    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)
    
    func testSendsContentTypeHeader() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
    }
    
    func testParseRetrievedTask() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)?
            .withJsonBody(fromJsonFile("getTaskByIdResponse"))
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues(task: (result?.value)!)

    }
    
    fileprivate func assertTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal("1"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }
    
//    func testParsesTasksProperlyGettingAllTheTasks() {
//        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
//            .andReturn(200)?
//            .withJsonBody(fromJsonFile("getTasksResponse"))
//
//        var result: Result<[TaskDTO], TODOAPIClientError>?
//        apiClient.getAllTasks { response in
//            result = response
//        }
//
//        expect(result?.value?.count).toEventually(equal(200))
//        assertTaskContainsExpectedValues(task: (result?.value?[0])!)
//    }
//
//    func testParsesTasksProperlyGettingEmptyTasks() {
//        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
//            .andReturn(200)?
//            .withJsonBody(fromJsonFile("getEmptyTasksResponse"))
//
//        var result: Result<[TaskDTO], TODOAPIClientError>?
//        apiClient.getAllTasks { response in
//            result = response
//        }
//
//        expect(result?.value?.count).toEventually(equal(0))
//    }
//
//    func testReturnsEmptyResponseWhenTheServerIsCrashing() {
//        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
//            .andReturn(500)
//
//        var result: Result<[TaskDTO], TODOAPIClientError>?
//        apiClient.getAllTasks { response in
//            result = response
//        }
//
//        expect(result).toEventually(beNil())
//    }
//
//    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() {
//        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
//            .andFailWithError(NSError.networkError())
//
//        var result: Result<[TaskDTO], TODOAPIClientError>?
//        apiClient.getAllTasks { response in
//            result = response
//        }
//
//        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
//    }
    
    
    private func assertTaskContainsExpectedValues(task: TaskDTO) {
        expect(task.id).to(equal("1"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }
}

