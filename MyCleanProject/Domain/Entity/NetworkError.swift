//
//  NetworkError.swift
//  MyCleanProject
//
//  Created by 박승환 on 1/20/25.
//

import Foundation

public enum NetworkError: Error {
    case urlError
    case invalidResponse
    case failToDecode(String)
    case dataNil
    case serverError(Int)
    case requestFailed(String)
    
    public var description: String {
        switch self {
        case .urlError:
            "URL이 올바르지 않습니다."
        case .invalidResponse:
            "응답값이 유효하지 않습니다."
        case .failToDecode(let description):
            "디코딩 에러 \(description)"
        case .dataNil:
            "데이터가 얿습니다."
        case .serverError(let statusCode):
            "서버에러 \(statusCode)"
        case .requestFailed(let message):
            "서버 요청 실패 \(message)"
        }
    }
}
