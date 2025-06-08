//
//  ErrorView.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI


struct ErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("deny")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("User successfully registered")
                .font(.custom("NunitoSans", size: 20))
                .multilineTextAlignment(.center)
            
            Button("Try again") {
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
