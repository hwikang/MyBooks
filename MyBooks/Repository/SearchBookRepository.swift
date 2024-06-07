//
//  BookRepository.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

protocol BookRepositoryProtocol {
    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError>
    func bookDetail(isbn: String) async -> Result<Book, NetworkError>

}

struct BookRepository: BookRepositoryProtocol {
    private let network: BookNetworkProtocol

    init(network: BookNetworkProtocol) {
        self.network = network
    }

    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError> {
        await network.searchBooks(query: query, page: page)
    }
    
    func bookDetail(isbn: String) async -> Result<Book, NetworkError> {
        await network.bookDetail(isbn: isbn)
    }
}
