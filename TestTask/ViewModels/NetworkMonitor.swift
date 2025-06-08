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
        
        return AF.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: UsersResponse.self)
            .value()
            .mapError { _ in APIError.networkError }
            .eraseToAnyPublisher()
    }
    
    func fetchPositions() -> AnyPublisher<PositionsResponse, APIError> {
        let url = "\(baseURL)/positions"
        
        return AF.request(url)
            .validate()
            .publishDecodable(type: PositionsResponse.self)
            .value()
            .mapError { _ in APIError.networkError }
            .eraseToAnyPublisher()
    }
    
    func registerUser(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, APIError> {
        // First get token, then register
        return getToken()
            .flatMap { token in
                self.performRegistration(request: request, token: token)
            }
            .eraseToAnyPublisher()
    }
    
    private func getToken() -> AnyPublisher<String, APIError> {
        let url = "\(baseURL)/token"
        
        return AF.request(url)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data,
                      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let token = json["token"] as? String else {
                    throw APIError.invalidResponse
                }
                return token
            }
            .mapError { _ in APIError.tokenError }
            .eraseToAnyPublisher()
    }
    
    private func performRegistration(request: RegistrationRequest, token: String) -> AnyPublisher<RegistrationResponse, APIError> {
        let url = "\(baseURL)/users"
        let headers: HTTPHeaders = ["Token": "Bearer \(token)"]
        
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
        .mapError { _ in APIError.registrationFailed }
        .eraseToAnyPublisher()
    }
}
