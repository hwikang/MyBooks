//
//  MockSearchRepository.swift
//  MyBooksTests
//
//  Created by paytalab on 6/7/24.
//

import Foundation
@testable import MyBooks

class MockBookRepository: BookRepositoryProtocol {
    var searchBooksResult: Result<BookList, NetworkError>?
    var bookDetailResult: Result<Book, NetworkError>? 
    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError> {
        return searchBooksResult ?? .failure(NetworkError.invalidResponse)
    }
    
    func bookDetail(isbn: String) async -> Result<Book, NetworkError> {
        return bookDetailResult ?? .failure(NetworkError.invalidResponse)
    }
    
}
