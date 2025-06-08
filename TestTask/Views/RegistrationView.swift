//
//  RegistrationView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers


struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
      @State private var showPhotoPicker = false
      @State private var selectedPhoto: PhotosPickerItem?
      
      var body: some View {
          NavigationView {
              if viewModel.showSuccess {
                  SuccessView {
                      viewModel.showSuccess = false
                  }
              } else {
                  ScrollView {
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
                              showPhotoPicker: $showPhotoPicker
                          )
                          
                          Button("Sign up") {
                              viewModel.registerUser()
                          }
                          .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isFormValid))
                          .disabled(!viewModel.isFormValid || viewModel.isLoading)
                          
                          if viewModel.isLoading {
                              ProgressView()
                          }
                      }
                      .padding()
                  }
                  .navigationTitle("Registration")
                  .navigationBarTitleDisplayMode(.inline)
                  .onAppear {
                      viewModel.loadPositions()
                  }
                  .photosPicker(
                      isPresented: $showPhotoPicker,
                      selection: $selectedPhoto,
                      matching: .images
                  )
                  .onChange(of: selectedPhoto) { item in
                      loadPhoto(from: item)
                  }
                  .alert("Error", isPresented: $viewModel.showError) {
                      Button("OK") { }
                  } message: {
                      Text(viewModel.errorMessage)
                  }
              }
          }
      }
      
      private func loadPhoto(from item: PhotosPickerItem?) {
          guard let item = item else { return }
          
          Task {
              if let data = try? await item.loadTransferable(type: Data.self) {
                  await MainActor.run {
                      viewModel.photoData = data
                  }
              }
          }
      }
}
