//
//  SuccessView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI

struct SuccessView: View {
    let result: RegistrationResult
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(result.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text(result.message)
                .font(.custom("NunitoSans", size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(result.buttonTitle) {
                onDismiss()
            }
            .frame(maxWidth: 140)
            .padding()
            .background(Color(hex: "#F4E041"))
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
    }
}
