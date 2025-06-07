//
//  APIResponses.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import Foundation


struct RegistrationRequest: Codable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: Data
    
    private enum CodingKeys: String, CodingKey {
        case name, email, phone, photo
        case positionId = "position_id"
    }
}

struct RegistrationResponse: Codable {
    let success: Bool
    let userId: Int?
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case success, message
        case userId = "user_id"
    }
}
