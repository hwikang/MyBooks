//
//  MockURLSession.swift
//  MyBooksTests
//
//  Created by paytalab on 6/6/24.
//

import Foundation
@testable import MyBooks

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
   func data(for request: URLRequest) async throws -> (Data, URLResponse) {
       if let error = mockError {
           throw error
       }
       guard let data = mockData, let response = mockResponse else {
           throw URLError(.badServerResponse)
       }
       return (data, response)
   }
}
