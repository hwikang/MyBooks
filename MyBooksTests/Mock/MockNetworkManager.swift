//
//  MockNetworkManager.swift
//  MyBooksTests
//
//  Created by paytalab on 6/6/24.
//

import Foundation
@testable import MyBooks
class MockNetworkManager: NetworkManagerProtocol {

    var session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }

    func fetchData<T: Decodable>(urlString: String, httpMethod: HTTPMethod, headers: [String : String]?) async -> Result<T, NetworkError> {
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.urlError(urlString))
        }
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: request)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.requestFail(error))
        }
    }
}
