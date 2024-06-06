//
//  NetworkManager.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

final class NetworkManager {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
        
    }
    
    func fetchData<T: Decodable>(urlString: String, httpMethod: String = "GET", headers: [String: String] = [:]) async -> Result<T,NetworkError> {
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.urlError(urlString))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
            let (data, response) = try await session.data(for: request)
            guard let response =  response as? HTTPURLResponse else { return .failure(NetworkError.invalidResponse) }
            if 200..<400 ~= response.statusCode {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return .success(decodedData)
                } catch let error {
                    return .failure(NetworkError.failToDecode(error.localizedDescription))
                }
            } else {
                return .failure(.serverError(response.statusCode))
            }

        } catch let error {
            return .failure(NetworkError.requestFail(error))
        }
    }
}
