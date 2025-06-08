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
            Image(systemName: "success")
                .frame(width: 200, height: 200)
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("User successfully registered")
                .font(.custom("NunitoSans", size: 20))
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
