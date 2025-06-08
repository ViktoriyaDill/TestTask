//
//  APIService.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import Network


class APIService: ObservableObject {
    static let shared = APIService()
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    
    func fetchUsers(page: Int = 1, count: Int = 6) async throws -> UsersResponse {
        let url = URL(string: "\(baseURL)/users?page=\(page)&count=\(count)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UsersResponse.self, from: data)
    }
    
    func fetchPositions() async throws -> PositionsResponse {
        let url = URL(string: "\(baseURL)/positions")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PositionsResponse.self, from: data)
    }
    
    func getToken() async throws -> String {
        let url = URL(string: "\(baseURL)/token")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        return response["token"] as! String
    }
    
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse {
        let token = try await getToken()
        
        let url = URL(string: "\(baseURL)/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Token")
        
        var body = Data()
        
        // Add form fields
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(name)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(email)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(phone)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(positionId)\r\n".data(using: .utf8)!)
        
        // Add photo
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photo)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(RegistrationResponse.self, from: data)
    }
}
