//
//  NetworkError.swift
//  MyBooks
//
//  Created by paytalab on 6/6/24.
//

import Foundation

public enum NetworkError: Error {
    case urlError(String)
    case requestFail(Error)
    case dataNil
    case invalidResponse
    case failToDecode(String)
    case serverError(Int)
}
