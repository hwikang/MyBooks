//
//  MockSearchRepository.swift
//  MyBooksTests
//
//  Created by paytalab on 6/7/24.
//

import Foundation
@testable import MyBooks

class MockBookRepository: BookRepositoryProtocol {
    var searchBooksResult: Result<BookList, NetworkError> = .success(BookList(page: 1, total: 0, books: []))
    var bookDetailResult: Result<Book, NetworkError> = .success(Book(title: "Title", subtitle: "SubTitle", isbn13: "9781617291609", price: "$19.99", image: "https://itbook.store/img/books/9781617291609.png", url: "https://itbook.store/books/9781449310370", authors: "Julien Vehent", publisher: "Manning", language: "English", isbn10: "1617294136", pages: "384", year: "2018", rating: "4", desc: "", pdf: ["Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf", "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"]))
    

    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError> {
        return searchBooksResult
        
    }
    
    func bookDetail(isbn: String) async -> Result<Book, NetworkError> {
        return bookDetailResult
    }
    
}
