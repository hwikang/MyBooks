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
                      "title": "Test Book",
                      "subtitle": "A test book",
                      "isbn13": "1234567890123",
                      "price": "$0",
                      "image": "http://example.com/image.jpg",
                      "url": "http://example.com",
                      "authors": "John Doe",
                      "publisher": "Test Publisher",
                      "language": "English",
                      "isbn10": "1234567890",
                      "pages": "100",
                      "year": "2020",
                      "rating": "5",
                      "desc": "Description"
                  }
              ]
          }
          """.data(using: .utf8)!
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.itbook.store/1.0/search/swift/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = await bookNetwork.searchBooks(query: "swift", page: 1)
        
        switch result {
        case .success(let bookList):
            XCTAssertEqual(bookList.books.count, 1)
            XCTAssertEqual(bookList.books.first?.title, "Test Book")
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
