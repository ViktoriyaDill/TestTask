//
//  ValidationService.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI


class ValidationService {
    static let shared = ValidationService()
    private init() {}
    
    func validateName(_ name: String) -> ValidationResult {
        if name.isEmpty {
            return .invalid("Name is required")
        }
        if name.count < 2 {
            return .invalid("Name should be at least 2 characters")
        }
        if name.count > 60 {
            return .invalid("Name should not exceed 60 characters")
        }
        return .valid
    }
    
    func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .invalid("Email is required")
        }
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email) ? .valid : .invalid("Invalid email format")
    }
    
    func validatePhone(_ phone: String) -> ValidationResult {
        if phone.isEmpty {
            return .invalid("Phone is required")
        }
        let cleanPhone = phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let phoneRegex = "^\\+380[0-9]{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: cleanPhone) ? .valid : .invalid("Phone should start with +380 and contain 13 characters")
    }
    
    func validatePhoto(_ data: Data?) -> ValidationResult {
        guard let data = data else {
            return .invalid("Photo is required")
        }
        let maxSize = 5 * 1024 * 1024 // 5MB
        if data.count > maxSize {
            return .invalid("Photo size should not exceed 5MB")
        }
        guard UIImage(data: data) != nil else {
            return .invalid("Invalid image format")
        }
        return .valid
    }
}
