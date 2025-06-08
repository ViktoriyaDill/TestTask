//
//  FormTextField.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI


struct FormTextField: View {
    let placeholder: String
    @Binding var text: String
    let errorMessage: String
    var keyboardType: UIKeyboardType = .default
    var helperText: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage.isEmpty ? Color.gray.opacity(0.5) : Color.red, lineWidth: 2)
                )
                .foregroundColor(errorMessage.isEmpty ? .primary : .red)
                .keyboardType(keyboardType)
            
            if let helperText = helperText, errorMessage.isEmpty {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
