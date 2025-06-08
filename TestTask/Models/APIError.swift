//
//  APIError.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


enum APIError: LocalizedError {
    case networkError
    case invalidResponse
    case tokenError
    case registrationFailed
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection error"
        case .invalidResponse:
            return "Invalid response from server"
        case .tokenError:
            return "Authentication token error"
        case .registrationFailed:
            return "Registration failed. Please try again."
        case .validationError(let message):
            return message
        }
    }
}
