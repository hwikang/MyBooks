//
//  NetworkManagerTests.swift
//  MyBooksTests
//
//  Created by paytalab on 6/6/24.
//

import XCTest
@testable import MyBooks

final class NetworkManagerTests: XCTestCase {
    private var networkManager: NetworkManager!
    private var mockURLSession: MockURLSession!
    

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(session: mockURLSession)
    }
   
    func testFetchDataSuccess() async {
        let expectedData = Data("{\"name\":\"Test\"}".utf8)
        mockURLSession.mockData = expectedData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                      statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result: Result<MockDecodable, NetworkError> = await networkManager.fetchData(urlString: "https://example.com", httpMethod: .get, headers: nil)

        switch result {
        case .success(let data):
            XCTAssertEqual(data.name, "Test")
        default:
            XCTFail("Network Success Fail \(result)")
        }
    }
    
    func testFetchDataDecodeError() async {
        let invalidData = Data("Invalid data".utf8)
        mockURLSession.mockData = invalidData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                      statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result: Result<MockDecodable, NetworkError> = await networkManager.fetchData(urlString: "https://example.com", httpMethod: .get, headers: nil)

        switch result {
        case .failure(let error):
            if case .failToDecode = error {
            } else {
                XCTFail("Decoding Error Fail \(error)")
            }
        default:
            XCTFail("Network Error Fail \(result)")
        }
    }
    
    func testFetchDataServerError() async {
        let urlString = "https://api.itbook.store/1.0/search/mongodb"
        mockURLSession.mockData = Data("{\"error\":\"error\"}".utf8)
        mockURLSession.mockError = nil
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: urlString)!,
                                                      statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let result: Result<MockDecodable, NetworkError> = await networkManager.fetchData(urlString: urlString, httpMethod: .get, headers: nil)
        
        switch result {
        case .failure(let error):
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Server Error Fail \(error)")
            }
        default:
            XCTFail("Network Error Fail \(result)")
        }
    }
}

struct MockDecodable: Decodable {
    let name: String
}
