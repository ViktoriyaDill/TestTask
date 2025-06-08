//
//  RegistrationViewModel.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI
import Combine


class RegistrationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var selectedPosition: Position?
    @Published var photoData: Data?
    @Published var positions: [Position] = []
    
    @Published var nameError = ""
    @Published var emailError = ""
    @Published var phoneError = ""
    @Published var photoError = ""
    
    @Published var isLoading = false
    @Published var showSuccess = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private let networkService: NetworkServiceProtocol
    private let validationService: ValidationService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        validationService: ValidationService = ValidationService.shared
    ) {
        self.networkService = networkService
        self.validationService = validationService
        setupValidation()
    }
    
    private func setupValidation() {
        // Real-time validation with Combine
        $name
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] name in
                self?.validationService.validateName(name).errorMessage ?? ""
            }
            .assign(to: \.nameError, on: self)
            .store(in: &cancellables)
        
        $email
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] email in
                self?.validationService.validateEmail(email).errorMessage ?? ""
            }
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)
        
        $phone
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] phone in
                self?.validationService.validatePhone(phone).errorMessage ?? ""
            }
            .assign(to: \.phoneError, on: self)
            .store(in: &cancellables)
        
        $photoData
            .map { [weak self] data in
                self?.validationService.validatePhoto(data).errorMessage ?? ""
            }
            .assign(to: \.photoError, on: self)
            .store(in: &cancellables)
    }
    
    var isFormValid: Bool {
        return nameError.isEmpty && !name.isEmpty &&
               emailError.isEmpty && !email.isEmpty &&
               phoneError.isEmpty && !phone.isEmpty &&
               photoError.isEmpty && photoData != nil &&
               selectedPosition != nil
    }
    
    func loadPositions() {
        networkService.fetchPositions()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to load positions: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    self?.positions = response.positions
                }
            )
            .store(in: &cancellables)
    }
    
    func registerUser() {
        guard isFormValid,
              let position = selectedPosition,
              let photo = photoData else { return }
        
        isLoading = true
        errorMessage = ""
        
        let request = RegistrationRequest(
            name: name,
            email: email,
            phone: phone,
            positionId: position.id,
            photo: photo
        )
        
        networkService.registerUser(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        self?.showSuccess = true
                        self?.resetForm()
                    } else {
                        self?.errorMessage = response.message
                        self?.showError = true
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedPosition = nil
        photoData = nil
    }
}
