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

extension URLSession: URLSessionProtocol {}
