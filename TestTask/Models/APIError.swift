//
//  APIError.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case invalidResponse
    case tokenExpired
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .tokenExpired:
            return "Authentication token expired"
        case .validationError(let message):
            return message
        }
    }
}
