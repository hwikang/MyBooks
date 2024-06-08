//
//  SearchViewModelTests.swift
//  MyBooksTests
//
//  Created by paytalab on 6/7/24.
//

import XCTest
import Combine
@testable import MyBooks

final class SearchViewModelTests: XCTestCase {
    private var viewModel: SearchViewModel!
    private var mockRepository: MockBookRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockBookRepository()
        viewModel = SearchViewModel(repository: mockRepository)
        cancellables = []
    }
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    
    func testSearchSuccess() {
        // Given
        let expect = expectation(description: "search books success")
        var books: [BookListItem]?
        
        let searchText = PassthroughSubject<String, Never>()
        let loadMore = PassthroughSubject<Void, Never>()
        
    
        // When
        let input = SearchViewModel.Input(searchText: searchText.eraseToAnyPublisher(), loadMore: loadMore.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.bookList
            .dropFirst()
            .sink { bookList in
                books = bookList
                expect.fulfill()
            }
            .store(in: &cancellables)
        
      
       
        mockRepository.searchBooksResult = .success(BookList(page: 1, total: 0, books: [
            BookListItem(title: "MongoDB in Action, 2nd Edition", subtitle: "SubTitle", isbn13: "9781617291609", price: "$19.99", image: "https://itbook.store/img/books/9781617291609.png", url: "https://itbook.store/books/9781449310370")
        ]))
        searchText.send("MongoDB")
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(books)
        XCTAssertEqual(books?.first?.title, "MongoDB in Action, 2nd Edition")
    }
    
    
    func testInvalidSearchTextFiltering() {
        // Given

        let expectationError = expectation(description: "Receive error message for invalid query")
        var error: String?
        let inputText = PassthroughSubject<String, Never>()
        let loadMore = PassthroughSubject<Void, Never>()
        
        // When
        let input = SearchViewModel.Input(searchText: inputText.eraseToAnyPublisher(), loadMore: loadMore.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.errorMessage
            .sink(receiveValue: { errorMessage in
                error = errorMessage
                expectationError.fulfill()
            })
            .store(in: &cancellables)
        
        // Invalid input
        inputText.send("@MongoDB!")
        
        // Then
        XCTAssertEqual(error, "유효 하지 않은 검색어입니다")
        wait(for: [expectationError], timeout: 1.0)
    }
}
