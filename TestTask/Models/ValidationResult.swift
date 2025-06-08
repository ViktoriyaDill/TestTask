//
//  ValidationResult.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import Foundation


enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }
    
    var errorMessage: String {
        switch self {
        case .valid: return ""
        case .invalid(let message): return message
        }
    }
}
