//
//  MockAPIService.swift
//  TestTaskTests
//
//  Created by Пользователь on 08.06.2025.
//

import XCTest
@testable import TestTask



class MockAPIService: ObservableObject{
    var shouldFailFetchUsers = false
        var shouldFailRegistration = false
        var registrationShouldReturnError: APIError?
        var fetchUsersDelay: Double = 0.5
        var registrationDelay: Double = 1.0
        
        // Mock data
        private let mockUsers: [User] = [
            User(id: 1, name: "John Doe", email: "john@example.com", phone: "+380123456789", position: "Developer", positionId: 1, registrationTimestamp: 1234567890, photo: "https://example.com/photo1.jpg"),
            User(id: 2, name: "Jane Smith", email: "jane@example.com", phone: "+380987654321", position: "Designer", positionId: 2, registrationTimestamp: 1234567891, photo: "https://example.com/photo2.jpg"),
            User(id: 3, name: "Bob Wilson", email: "bob@example.com", phone: "+380555666777", position: "Manager", positionId: 3, registrationTimestamp: 1234567892, photo: "https://example.com/photo3.jpg")
        ]
        
        private let mockPositions: [Position] = [
            Position(id: 1, name: "Developer"),
            Position(id: 2, name: "Designer"),
            Position(id: 3, name: "Manager"),
            Position(id: 4, name: "QA Engineer")
        ]
        
        // MARK: - Mock Implementation
        func fetchUsers(page: Int = 1, count: Int = 6) async throws -> UsersResponse {
            // Simulate network delay
            try await Task.sleep(nanoseconds: UInt64(fetchUsersDelay * 1_000_000_000))
            
            if shouldFailFetchUsers {
                throw APIError.networkError(NSError(domain: "Mock", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock network error"]))
            }
            
            // Simulate pagination
            let startIndex = (page - 1) * count
            let endIndex = min(startIndex + count, mockUsers.count)
            let paginatedUsers = Array(mockUsers[startIndex..<endIndex])
            
            return UsersResponse(
                success: true,
                totalPages: Int(ceil(Double(mockUsers.count) / Double(count))),
                totalUsers: mockUsers.count,
                count: paginatedUsers.count,
                page: page,
                links: Links(nextUrl: nil, prevUrl: nil),
                users: paginatedUsers
            )
        }
        
        func fetchPositions() async throws -> PositionsResponse {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            return PositionsResponse(
                success: true,
                positions: mockPositions
            )
        }
        
        func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data) async throws -> RegistrationResponse {
            // Simulate network delay
            try await Task.sleep(nanoseconds: UInt64(registrationDelay * 1_000_000_000))
            
            if shouldFailRegistration {
                throw APIError.networkError(NSError(domain: "Mock", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock registration failed"]))
            }
            
            if let error = registrationShouldReturnError {
                throw error
            }
            
            // Simulate validation
            if name.count < 2 {
                throw APIError.validationError("Name should be at least 2 characters")
            }
            
            if !email.contains("@") {
                throw APIError.validationError("Invalid email format")
            }
            
            if phone.count < 10 {
                throw APIError.validationError("Invalid phone number")
            }
            
            // Mock successful registration
            let newUser = User(
                id: mockUsers.count + 1,
                name: name,
                email: email,
                phone: phone,
                position: mockPositions.first { $0.id == positionId }?.name ?? "Unknown",
                positionId: positionId,
                registrationTimestamp: Int(Date().timeIntervalSince1970),
                photo: "https://example.com/new-photo.jpg"
            )
            
            return RegistrationResponse(
                success: true,
                userId: newUser.id,
                message: "New user successfully registered"
            )
        }
}

extension MockAPIService {
    
    // Preset configurations
    static func successMock() -> MockAPIService {
        let mock = MockAPIService()
        mock.shouldFailFetchUsers = false
        mock.shouldFailRegistration = false
        return mock
    }
    
    static func networkErrorMock() -> MockAPIService {
        let mock = MockAPIService()
        mock.shouldFailFetchUsers = true
        mock.shouldFailRegistration = true
        return mock
    }
    
    static func validationErrorMock() -> MockAPIService {
        let mock = MockAPIService()
        mock.registrationShouldReturnError = .validationError("Email already exists")
        return mock
    }
    
    static func slowNetworkMock() -> MockAPIService {
        let mock = MockAPIService()
        mock.fetchUsersDelay = 3.0
        mock.registrationDelay = 5.0
        return mock
    }
}
