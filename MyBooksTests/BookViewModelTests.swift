//
//  BookViewModelTests.swift
//  MyBooksTests
//
//  Created by paytalab on 6/8/24.
//

import XCTest
import Combine
@testable import MyBooks

class BookViewModelTests: XCTestCase {
    var viewModel: BookViewModel!
    var mockRepository: MockBookRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockBookRepository()
        viewModel = BookViewModel(repository: mockRepository, isbn: "9781617291609")
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testBookFetchSuccess() {
        // Given
        let expectation = expectation(description: "Fetch book success")
        var book: Book?
        let trigger = PassthroughSubject<Void, Never>()

        // When
        let input = BookViewModel.Input(trigger: trigger.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.book
            .sink { bookResult in
                book = bookResult
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        mockRepository.bookDetailResult = .success(Book(title: "Book Title", subtitle: "SubTitle", isbn13: "9781617291609", price: "$19.99", image: "https://itbook.store/img/books/9781617291609.png", url: "https://itbook.store/books/9781449310370", authors: "Julien Vehent", publisher: "Manning", language: "English", isbn10: "1617294136", pages: "384", year: "2018", rating: "4", desc: "", pdf: ["Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf", "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"]))
        trigger.send()
        // Then
        waitForExpectations(timeout: 5.0)
        XCTAssertNotNil(book)
        XCTAssertEqual(book?.title, "Book Title")
    }
    
}
