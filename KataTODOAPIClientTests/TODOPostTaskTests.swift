//
//  TODOPostTaskTests.swift
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

class TODOPostTaskTests: NocillaTestCase {
    
    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)
    
    func testSendsContentTypeHeader() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "title", completed: false) { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
        expect { try result }.toEventuallyNot(throwError())
    }
    
    func testParsesTheTaskCreatedProperlyAddingANewTask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)?
            .withJsonBody(fromJsonFile("addTaskToUserRequest"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "title", completed: false) { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
        expect { try result }.toEventuallyNot(throwError())
    }
    
    func testReturnsUnknowErrorIfThereIsAnyErrorAddingATask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andFailWithError(NSError.networkError())
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "title", completed: false) { response in
            result = response
        }
        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }
        
}

