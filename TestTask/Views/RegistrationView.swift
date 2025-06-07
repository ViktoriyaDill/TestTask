//
//  RegistrationView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import PhotosUI


struct RegistrationView: View {
    @StateObject private var apiService = APIService()
    @State private var positions: [Position] = []
    @State private var selectedPosition: Position?
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showPhotoPicker = false
    
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    // Validation states
    @State private var nameError = ""
    @State private var emailError = ""
    @State private var phoneError = ""
    @State private var photoError = ""
    
    var body: some View {
        NavigationView {
            if showSuccess {
                SuccessView()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Name field
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Your name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: name) { _ in
                                    validateName()
                                }
                            
                            if !nameError.isEmpty {
                                Text(nameError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .onChange(of: email) { _ in
                                    validateEmail()
                                }
                            
                            if !emailError.isEmpty {
                                Text(emailError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Phone field
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Phone", text: $phone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                                .onChange(of: phone) { _ in
                                    validatePhone()
                                }
                            
                            Text("+38 (XXX) XXX - XX - XX")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if !phoneError.isEmpty {
                                Text(phoneError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Position selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select your position")
                                .font(.headline)
                            
                            ForEach(positions) { position in
                                HStack {
                                    Button(action: {
                                        selectedPosition = position
                                    }) {
                                        HStack {
                                            Image(systemName: selectedPosition?.id == position.id ? "largecircle.fill.circle" : "circle")
                                                .foregroundColor(selectedPosition?.id == position.id ? .blue : .gray)
                                            Text(position.name)
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Photo upload
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Button("Upload your photo") {
                                    showPhotoPicker = true
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                
                                Spacer()
                                
                                if photoData != nil {
                                    Text("Upload")
                                        .foregroundColor(.blue)
                                } else {
                                    Text("Upload")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if !photoError.isEmpty {
                                Text(photoError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Sign up button
                        Button("Sign up") {
                            Task {
                                await registerUser()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid() ? Color.yellow : Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .disabled(!isFormValid() || isLoading)
                        
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .padding()
                }
                .navigationTitle("Working with POST request")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await loadPositions()
                }
                .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
                .onChange(of: selectedPhoto) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            photoData = data
                            validatePhoto()
                        }
                    }
                }
                .alert("Error", isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func loadPositions() async {
        do {
            let response = try await apiService.fetchPositions()
            DispatchQueue.main.async {
                self.positions = response.positions
            }
        } catch {
            // Handle error
        }
    }
    
    private func validateName() {
        if name.count < 2 || name.count > 60 {
            nameError = "Name should be 2-60 characters"
        } else {
            nameError = ""
        }
    }
    
    private func validateEmail() {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            emailError = "Invalid email format"
        } else {
            emailError = ""
        }
    }
    
    private func validatePhone() {
        let phoneRegex = "^[+]{0,1}380([0-9]{9})$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if !phonePredicate.evaluate(with: phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")) {
            phoneError = "Phone should start with +380 and contain 13 characters"
        } else {
            phoneError = ""
        }
    }
    
    private func validatePhoto() {
        guard let data = photoData else {
            photoError = "Photo is required"
            return
        }
        
        if data.count > 5 * 1024 * 1024 { // 5MB
            photoError = "Photo size should not exceed 5MB"
        } else {
            photoError = ""
        }
    }
    
    private func isFormValid() -> Bool {
        return !name.isEmpty && nameError.isEmpty &&
               !email.isEmpty && emailError.isEmpty &&
               !phone.isEmpty && phoneError.isEmpty &&
               selectedPosition != nil &&
               photoData != nil && photoError.isEmpty
    }
    
    private func registerUser() async {
        guard let position = selectedPosition,
              let photo = photoData else { return }
        
        isLoading = true
        
        do {
            let response = try await apiService.registerUser(
                name: name,
                email: email,
                phone: phone,
                positionId: position.id,
                photo: photo
            )
            
            DispatchQueue.main.async {
                self.isLoading = false
                if response.success {
                    self.showSuccess = true
                } else {
                    self.errorMessage = response.message
                    self.showError = true
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Registration failed. Please try again."
                self.showError = true
            }
        }
    }
}
