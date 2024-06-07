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
    
    var description: String {
        switch self {
        case .urlError(let url): return "URL 이 유효하지 않습니다. \(url)"
        case .dataNil: return "응답 데이터가 없습니다"
        case.failToDecode(let message): return "디코딩 에러 발생 \(message)"
        case .requestFail(let error): return "서버요청 실패 \(error.localizedDescription)"
        case .invalidResponse: return "유효하지 않은 응답입니다."
        case .serverError(let code): return "서버에러 발생 \(code)"
        }
    }
}
