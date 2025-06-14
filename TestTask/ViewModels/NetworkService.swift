//
//  NetworkMonitor.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import Alamofire
import Combine

protocol NetworkServiceProtocol {
    func fetchUsers(page: Int, count: Int) -> AnyPublisher<UsersResponse, APIError>
    func fetchPositions() -> AnyPublisher<PositionsResponse, APIError>
    func registerUser(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, APIError>
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    private init() {}
    
    func fetchUsers(page: Int = 1, count: Int = 6) -> AnyPublisher<UsersResponse, APIError> {
        let url = "\(baseURL)/users"
        let parameters: [String: Any] = ["page": page, "count": count]
        
        print("Fetching users from: \(url)")
        print("Parameters: \(parameters)")
        
        return AF.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: UsersResponse.self)
            .value()
            .handleEvents(
                receiveOutput: { response in
                    print("Users loaded successfully: \(response.users.count) users")
                }
            )
            .mapError { error in
                print("Users fetch error: \(error)")
                return APIError.networkError
            }
            .eraseToAnyPublisher()
    }
    
    func fetchPositions() -> AnyPublisher<PositionsResponse, APIError> {
        let url = "\(baseURL)/positions"
        
        print("Fetching positions from: \(url)")
        
        return AF.request(url)
            .validate()
            .publishDecodable(type: PositionsResponse.self)
            .value()
            .handleEvents(
                receiveOutput: { response in
                    print("Positions loaded successfully: \(response.positions.count) positions")
                    for position in response.positions {
                        print("Position: \(position.id) - \(position.name)")
                    }
                }
            )
            .mapError { error in
                print("Positions fetch error: \(error)")
                if let afError = error as? AFError {
                    print("AFError details: \(afError.localizedDescription)")
                    if let responseCode = afError.responseCode {
                        print("Response code: \(responseCode)")
                    }
                }
                return APIError.networkError
            }
            .eraseToAnyPublisher()
    }
    
    func registerUser(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, APIError> {
        print("Starting user registration process...")
        
        return getToken()
            .flatMap { token in
                print("Token received, proceeding with registration")
                return self.performRegistration(request: request, token: token)
            }
            .eraseToAnyPublisher()
    }
    
    private func getToken() -> AnyPublisher<String, APIError> {
        let url = "\(baseURL)/token"
        
        print("Getting token from: \(url)")
        
        return AF.request(url)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data,
                      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let token = json["token"] as? String else {
                    print("Failed to parse token response")
                    throw APIError.invalidResponse
                }
                print("Token received successfully")
                return token
            }
            .mapError { error in
                print("Token fetch error: \(error)")
                return APIError.tokenError
            }
            .eraseToAnyPublisher()
    }
    
    private func performRegistration(request: RegistrationRequest, token: String) -> AnyPublisher<RegistrationResponse, APIError> {
        let url = "\(baseURL)/users"
        let headers: HTTPHeaders = ["Token": token]
        
        print("Performing registration to: \(url)")
        print("Registration data:")
        print("Name: \(request.name)")
        print("Email: \(request.email)")
        print("Phone: \(request.phone)")
        print("Position ID: \(request.positionId)")
        print("Photo size: \(request.photo.count) bytes")
        
        return AF.upload(
            multipartFormData: { formData in
                formData.append(request.name.data(using: .utf8)!, withName: "name")
                formData.append(request.email.data(using: .utf8)!, withName: "email")
                formData.append(request.phone.data(using: .utf8)!, withName: "phone")
                formData.append("\(request.positionId)".data(using: .utf8)!, withName: "position_id")
                formData.append(request.photo, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
            },
            to: url,
            headers: headers
        )
        .validate()
        .publishDecodable(type: RegistrationResponse.self)
        .value()
        .handleEvents(
            receiveOutput: { response in
                print("Registration response received")
                print("Success: \(response.success)")
                print("Message: \(response.message)")
                if let userId = response.userId {
                    print("   User ID: \(userId)")
                }
            }
        )
        .mapError { error in
            print("Registration error: \(error)")
            if let afError = error as? AFError {
                print("AFError details: \(afError.localizedDescription)")
                if let responseCode = afError.responseCode {
                    print("Response code: \(responseCode)")
                }
            }
            return APIError.registrationFailed
        }
        .eraseToAnyPublisher()
    }
}
