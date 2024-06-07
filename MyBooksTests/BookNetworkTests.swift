//
//  BookNetworkTests.swift
//  MyBooksTests
//
//  Created by paytalab on 6/6/24.
//

import XCTest
@testable import MyBooks

final class BookNetworkTests: XCTestCase {

    var bookNetwork: BookNetwork!
     var mockURLSession: MockURLSession!
     var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockNetworkManager = MockNetworkManager(session: mockURLSession)
        bookNetwork = BookNetwork(network: mockNetworkManager)
    }

    func testSearchBooksSuccess() async {
        let jsonData = """
          {
              "page": "1",
              "total": "1",
              "books": [
                  {
                     "title": "MongoDB in Action, 2nd Edition",
                     "subtitle": "Covers MongoDB version 3.0",
                     "isbn13": "9781617291609",
                     "price": "$19.99",
                     "image": "https://itbook.store/img/books/9781617291609.png",
                     "url": "https://itbook.store/books/9781617291609"
                  }
              ]
          }
          """.data(using: .utf8)!
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.itbook.store/1.0/search/swift/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = await bookNetwork.searchBooks(query: "mongodb", page: 1)
        
        switch result {
        case .success(let bookList):
            XCTAssertEqual(bookList.books.count, 1)
            XCTAssertEqual(bookList.books.first?.title, "MongoDB in Action, 2nd Edition")
        case .failure(let error):
            XCTFail("Search Book Fail \(error)")
        }
    }
    
    func testSearchBooksFailure() async {
        mockURLSession.mockError = URLError(.badServerResponse)
        
        let result = await bookNetwork.searchBooks(query: "error query", page: 1)
        
        switch result {
        case .success:
            XCTFail("Search Book Error Fail")
        case .failure:
            XCTAssertTrue(true)
        }
    }

}
