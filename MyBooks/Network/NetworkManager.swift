//
//  NetworkManager.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {}


final class NetworkManager {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(urlString: String) async -> Result<T,NetworkError> {
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.urlError(urlString))
        }
        do {
            let (data, response) = try await session.data(from: url)
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
