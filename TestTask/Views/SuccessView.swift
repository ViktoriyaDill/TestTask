//
//  SuccessView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct SuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("User successfully registered")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button("Got it") {
                // Handle navigation back
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding()
    }
}
