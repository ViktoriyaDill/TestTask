//
//  RegistrationView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import UIKit


struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            if viewModel.showResult, let result = viewModel.registrationResult {
                SuccessView(result: result) { viewModel.dismissResult() }
                
            } else {
                ScrollView {
                    MainNavTitle(request: "POST")
                    
                    VStack(spacing: 20) {
                        FormTextField(
                            placeholder: "Your name",
                            text: $viewModel.name,
                            errorMessage: viewModel.nameError
                        )
                        FormTextField(
                            placeholder: "Email",
                            text: $viewModel.email,
                            errorMessage: viewModel.emailError,
                            keyboardType: .emailAddress
                        )
                        FormTextField(
                            placeholder: "Phone",
                            text: $viewModel.phone,
                            errorMessage: viewModel.phoneError,
                            keyboardType: .phonePad,
                            helperText: "+38 (XXX) XXX - XX - XX"
                        )
                        PositionSelectionView(
                            positions: viewModel.positions,
                            selectedPosition: $viewModel.selectedPosition
                        )
                        PhotoUploadView(
                            photoData: viewModel.photoData,
                            errorMessage: viewModel.photoError,
                            showPicker: $showSourceDialog
                        )
                        Button("Sign up") { viewModel.registerUser() }
                            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isFormValid))
                            .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        
                        if viewModel.isLoading { ProgressView() }
                    }
                    .padding()
                    .onAppear {
                        viewModel.loadPositions()
                    }
                }
                
                .confirmationDialog(
                    "Choose how you want to add a photo",
                    isPresented: $showSourceDialog,
                    titleVisibility: .visible
                ) {
                    Button("Camera") {
                        sourceType = .camera
                        showImagePicker = true
                    }
                    Button("Gallery") {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(
                        data: $viewModel.photoData,
                        encoding: .jpeg(compressionQuality: 0.8),
                        sourceType: sourceType
                    )
                }
            }
        }
    }
}


