//
//  URLSessionProtocol.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

class BookURLSession: URLSessionProtocol {
    private var session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
