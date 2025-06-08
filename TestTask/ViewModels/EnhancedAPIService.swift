//
//  EnhancedAPIService.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI



protocol APIServiceProtocol {
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponse
    func fetchPositions() async throws -> PositionsResponse
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse
}


class APIServiceFactory {
    static var useMock = false
    
    static func create() -> APIServiceProtocol {
        if useMock {
            return MockAPIService()
        } else {
            return EnhancedAPIService.shared
        }
    }
}


class EnhancedAPIService: ObservableObject, APIServiceProtocol {
    static let shared = EnhancedAPIService()
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    private var cachedToken: String?
    private var tokenExpiryDate: Date?
    
    private init() {}
    
    // MARK: - Token Management
    private func getValidToken() async throws -> String {
        if let token = cachedToken,
           let expiry = tokenExpiryDate,
           Date() < expiry {
            return token
        }
        
        guard let url = URL(string: "\(baseURL)/token") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let token = json?["token"] as? String else {
                throw APIError.decodingError(NSError(domain: "TokenError", code: 0))
            }
            
            // Cache token for 30 minutes
            self.cachedToken = token
            self.tokenExpiryDate = Date().addingTimeInterval(30 * 60)
            
            return token
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Users API
    func fetchUsers(page: Int = 1, count: Int = 6) async throws -> UsersResponse {
        guard let url = URL(string: "\(baseURL)/users?page=\(page)&count=\(count)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                return try JSONDecoder().decode(UsersResponse.self, from: data)
            case 404:
                throw APIError.validationError("Page not found")
            case 422:
                throw APIError.validationError("Invalid parameters")
            default:
                throw APIError.invalidResponse
            }
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Positions API
    func fetchPositions() async throws -> PositionsResponse {
        guard let url = URL(string: "\(baseURL)/positions") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            return try JSONDecoder().decode(PositionsResponse.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Registration API
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse {
        let token = try await getValidToken()
        
        guard let url = URL(string: "\(baseURL)/users") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Token")
        
        let body = createMultipartBody(
            boundary: boundary,
            name: name,
            email: email,
            phone: phone,
            positionId: positionId,
            photo: photo
        )
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            let registrationResponse = try JSONDecoder().decode(RegistrationResponse.self, from: data)
            
            switch httpResponse.statusCode {
            case 201:
                return registrationResponse
            case 401:
                throw APIError.tokenExpired
            case 409:
                throw APIError.validationError("User with this phone or email already exists")
            case 422:
                throw APIError.validationError(registrationResponse.message)
            default:
                throw APIError.validationError(registrationResponse.message)
            }
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Helper Methods
    private func createMultipartBody(boundary: String, name: String, email: String, phone: String, positionId: Int, photo: Data) -> Data {
        var body = Data()
        
        // Add text fields
        let fields = [
            "name": name,
            "email": email,
            "phone": phone,
            "position_id": "\(positionId)"
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add photo
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photo)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
