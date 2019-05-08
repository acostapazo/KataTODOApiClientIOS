//
//  TODOUpdateTaskTests.swift
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

class TODOUpdateTaskTests: NocillaTestCase {
    
    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)
    
    func testSendsContentTypeHeader() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/2")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
        expect { try result }.toEventuallyNot(throwError())
    }
    
    func testParseCorrectlyDeletingAnInvalidTaskId() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/2")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(404)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }
        
        expect(result).toEventuallyNot(beNil())
        expect { try result?.error }.toEventually(equal(TODOAPIClientError.itemNotFound))
    }
    
//    func testParseCorrectlyDeletingAnInvalidTaskId() {
//        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/2")
//            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
//            .andReturn(404)
//
//        var result: Result<Void, TODOAPIClientError>?
//        apiClient.deleteTaskById("2") { response in
//            result = response
//        }
//
//        expect { try result?.error }.toEventually(equal(TODOAPIClientError.itemNotFound))
//    }
//
//    func testReturnsNetworkErrorIfThereIsNoConnectionDeletingTask() {
//        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/2")
//            .andFailWithError(NSError.networkError())
//
//        var result: Result<Void, TODOAPIClientError>?
//        apiClient.deleteTaskById("2") { response in
//            result = response
//        }
//
//        expect { try result?.error }.toEventually(equal(TODOAPIClientError.networkError))
//    }
//
//    func testReturnsUnknownErrorIfThereIsAnyErrorDeletingTask() {
//        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/2")
//            .andReturn(418)
//
//        var result: Result<Void, TODOAPIClientError>?
//        apiClient.deleteTaskById("2") { response in
//            result = response
//        }
//
//        expect { try result?.error }.toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
//    }
    
    
}

