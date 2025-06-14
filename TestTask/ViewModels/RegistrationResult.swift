//
//  RegistrationResult.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI

// MARK: - Result State Enum

enum RegistrationResult {
    case success
    case error(String)
    
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .error: return false
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "User successfully registered"
        case .error:
            return "That email is already registered"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .success: return "Got it"
        case .error: return "Try again"
        }
    }
    
    var iconName: String {
        switch self {
        case .success: return "success"
        case .error: return "deny"
        }
    }
}
