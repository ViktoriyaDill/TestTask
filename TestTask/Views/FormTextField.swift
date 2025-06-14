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

    @State private var isTouched = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            (isTouched && !errorMessage.isEmpty)
                                ? Color.red
                                : Color.gray.opacity(0.5),
                            lineWidth: 1
                        )
                )
                .keyboardType(keyboardType)
                .onChange(of: text) { _ in
                    isTouched = true
                }

            if let helper = helperText, errorMessage.isEmpty {
                Text(helper)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if isTouched && !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
