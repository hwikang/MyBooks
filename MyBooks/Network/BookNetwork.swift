//
//  BookNetwork.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

protocol BookNetworkProtocol {
    func search(query: String, page: Int) async -> Result<BookList, NetworkError>
}

final class BookNetwork: BookNetworkProtocol {
    private let network: NetworkManager
    private let endPoint = "https://api.itbook.store/1.0/search"
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func search(query: String, page: Int) async -> Result<BookList, NetworkError> {
        await network.fetchData(urlString: "\(endPoint)/\(query)/\(page)")
    }
}
