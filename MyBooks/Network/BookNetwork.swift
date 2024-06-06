//
//  BookNetwork.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

protocol BookNetworkProtocol {
    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError>
    func bookDetail(isbn: String) async -> Result<Book, NetworkError>

}

final class BookNetwork: BookNetworkProtocol {
    private let network: NetworkManagerProtocol
    private let endPoint = "https://api.itbook.store/1.0"
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError> {
        await network.fetchData(urlString: "\(endPoint)/search/\(query)/\(page)", httpMethod: .get, headers: nil)
    }
    
    func bookDetail(isbn: String) async -> Result<Book, NetworkError> {
        await network.fetchData(urlString: "\(endPoint)/\(isbn)", httpMethod: .get, headers: nil)
    }
}
