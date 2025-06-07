//
//  ValidationUtilities.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import Foundation


struct ValidationUtilities {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func validatePhone(_ phone: String) -> Bool {
        let cleanPhone = phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let phoneRegex = "^\\+380[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: cleanPhone)
    }
    
    static func formatPhoneNumber(_ phone: String) -> String {
        let cleanPhone = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleanPhone.hasPrefix("380") && cleanPhone.count == 12 {
            let formatted = "+380 (\(cleanPhone.prefix(5).suffix(2))) \(cleanPhone.prefix(8).suffix(3)) \(cleanPhone.prefix(10).suffix(2)) \(cleanPhone.suffix(2))"
            return formatted
        }
        
        return phone
    }
}
